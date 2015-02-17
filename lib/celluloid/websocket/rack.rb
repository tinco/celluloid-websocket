require 'celluloid'
require 'celluloid/io'
require 'celluloid/websocket'
require 'celluloid/io/rack_socket'
require 'rack/request'
require 'forwardable'

module Celluloid
	class WebSocket
		def self.rack(klass, config={})
			proc do |env|
				# We need to create the pool in the first request
				# because we might've been forked before.
				@pool ||= klass.pool(config)
				@pool.(env)
			end
		end

		class Rack
			extend Forwardable
			include Celluloid

			finalizer :shutdown

			def_delegators :@websocket, :socket, :env, :addr, :peeraddr, :read, :read_every, :write, :<<, :closed?, :close, :cancel_timer!

			def call(env)
				if env['HTTP_UPGRADE'].nil? || env['HTTP_UPGRADE'].downcase != 'websocket'
					return [400, {}, "No Upgrade header or Upgrade not for websocket."]
				end

				env['rack.hijack'].call
				socket = Celluloid::IO::RackSocket.new(env['rack.hijack_io'].to_io)

				async.initialize_websocket(env, socket)
				[200,{},""]
			end

			def initialize_websocket(req, socket)
				@websocket = WebSocket.new(req, socket)
				on_open if respond_to? :on_open
			end

			def shutdown
				@websocket.close if @websocket
			end
		end
	end
end

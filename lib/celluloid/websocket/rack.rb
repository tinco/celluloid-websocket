require 'celluloid/websocket'
require 'celluloid/io/rack_socket'
require 'rack/request'
require 'forwardable'

module Celluloid
	class WebSocket
		class Rack
			extend Forwardable

			def_delegators :@websocket, :socket, :env, :addr, :peeraddr, :read, :read_every, :write, :<<, :closed?, :close, :cancel_timer!

			def call(env)
				if env['HTTP_UPGRADE'].nil? || env['HTTP_UPGRADE'].downcase != 'websocket'
					return [400, {}, "No Upgrade header or Upgrade not for websocket."]
				end

        		env['rack.hijack'].call
				socket = Celluloid::IO::RackSocket.new(env['rack.hijack_io'])
				initialize_websocket(env, socket)

				on_open if respond_to? :on_open
			end

			def initialize_websocket(req, socket)
				@websocket = WebSocket.new(req, socket)
				[:next_message, :next_messages, :on_message, :on_error, :on_close, :on_ping, :on_pong].each do |meth|
					@websocket.send(meth) do |*args, &proc|
						self.send(meth, *args, &proc)
					end
				end
			end
		end
	end
end

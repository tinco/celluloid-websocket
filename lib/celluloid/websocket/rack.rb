require 'celluloid'
require 'celluloid/io'
require 'celluloid/websocket'
require 'celluloid/io/rack_socket'
require 'rack/request'
require 'forwardable'

module Celluloid
	class WebSocket
		def self.rack(config={})
			if defined?(PhusionPassenger)
				PhusionPassenger.advertised_concurrency_level = 0
			end

			lambda do |env|
				if env['HTTP_UPGRADE'].nil? || env['HTTP_UPGRADE'].downcase != 'websocket'
					return [400, {}, "No Upgrade header or Upgrade not for websocket."]
				end

				env['rack.hijack'].call
				socket = Celluloid::IO::RackSocket.new(env['rack.hijack_io'].to_io)
				
				new(*config[:args]).async.initialize_websocket(env, socket)
				[200,{},""]
			end
		end
	end
end

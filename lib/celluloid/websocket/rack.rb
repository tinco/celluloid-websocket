require 'celluloid/websocket'
require 'rack/request'

module Celluloid
	class WebSocket
		class Rack
			def call(env)
				if env['HTTP_UPGRADE'].nil? || env['HTTP_UPGRADE'].downcase != 'websocket'
					return [400, {}, "No Upgrade header or Upgrade not for websocket."]
				end

        		env['rack.hijack'].call
				socket = env['rack.hijack_io']
				initialize_websocket(env, socket)
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

require 'celluloid/websocket'
require 'rack/request'

module Celluloid
	class WebSocket
		class Rack
			def call(env)
				env['rack.hijack'].call
				socket = env['rack.hijack_io']
				req = ::Rack::Request.new(env)
				initialize_websocket(req, socket)
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

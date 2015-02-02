require 'celluloid/websocket/rack'

class WebSocketEcho < Celluloid::WebSocket::Rack
	def on_open
		@counter = 0

		while(true)
			message = read

			@counter += 1
			write("#{@counter}: #{message}")
		end
	end

	def on_error(*args)
		puts args.inspect
	end
end

run(WebSocketEcho)

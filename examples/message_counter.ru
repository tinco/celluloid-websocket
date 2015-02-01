require 'celluloid/websocket/rack'

class WebSocketEcho < Celluloid::WebSocket::Rack
	def on_open
		@counter = 0
		puts "Got opened"

		while(true)
			message = read
			puts "Read a message: #{message}"
		end
	end

	def on_ping
		puts "Got a ping!"
	end

	def on_message(message)
		@counter += 1
		write("#{@counter}: #{message}")
	end
end

use Rack::ShowExceptions
run(WebSocketEcho.new)

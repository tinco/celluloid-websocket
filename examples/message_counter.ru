require 'celluloid/websocket/rack'

class WebSocketEcho < Celluloid::WebSocket
	include Celluloid::Logger

	def on_open
		@counter = 0
		while(true)
			message = read

			@counter += 1
			write("#{@counter}: #{message}")
		end
	rescue => e
		info "Exiting because: #{e.message}"
		close
	end

	def on_error(*args)
		puts args.inspect
	end
end

run WebSocketEcho.rack

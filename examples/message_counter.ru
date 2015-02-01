require 'celluloid/websocket/rack'

class WebSocketEcho < Celluloid::WebSocket::Rack
    def initialize
        @counter = 0
    end

    def on_message(message)
        @counter += 1
        write("#{@counter}: #{message}")
    end
end

use Rack::ShowExceptions
run WebSocketEcho.new

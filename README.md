# Celluloid::WebSocket::Rack

Lets you make a websocket rack application using Celluloid.

This is basically a small wrapper around Tony Arcieri's Reel::Websocket class.

## Installation

Add this line to your application's Gemfile:

    gem 'celluloid-websocket-rack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install celluloid-websocket-rack

## Usage

Simply inherit your Rack app from Celluloid::WebSocket::Rack, and use the on_* handlers to build a protocol:

```
class WebSocketEcho < Celluloid::WebSocket::Rack
	def initialize
		@counter = 0
	end

	def on_message(message)
		@counter += 1
		write("#{@counter}: #{message}")
	end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

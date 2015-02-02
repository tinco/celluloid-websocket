# Celluloid::WebSocket

Lets you make a websocket rack application using Celluloid.

With thanks to Tony Arcieri for his awesome Celluloid libraries.

## Installation

Add this line to your application's Gemfile:

    gem 'celluloid-websocket'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install celluloid-websocket

## Usage

Simply inherit your Rack app from Celluloid::WebSocket::Rack, and use the on_* handlers to build a protocol:

```
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
end

run(WebSocketEcho)
```

You can try it out by cloning this repository, going to the examples directory and running:

```
passenger start -R message_counter.ru
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

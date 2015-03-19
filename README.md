# Celluloid::WebSocket

[![Join the chat at https://gitter.im/d-snp/celluloid-websocket](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/d-snp/celluloid-websocket?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

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

Simply inherit your Rack app from Celluloid::WebSocket::Rack, and implement the `on_open` method and using the `read` and `write` functions to implement a protocol. 

```
require 'celluloid/websocket/rack'

class WebSocketEcho < Celluloid::WebSocket
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

run WebSocketEcho.rack

```

You can try it out by cloning this repository running `bundle` and then:

```
passenger start -R examples/message_counter.ru
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

require 'forwardable'
require 'websocket/driver'
require 'uri'
require 'rack/request'

module Celluloid
	class WebSocket
		extend Forwardable
		include Celluloid

		finalizer :shutdown

		attr_accessor :socket, :env

		def initialize_websocket(env, socket)
			@env = env
			@socket = socket

			driver_env = DriverEnvironment.new(env, socket) 

			@driver = ::WebSocket::Driver.rack(driver_env)

			@driver.on(:close) do
				@socket.close
			end

			@message_stream = MessageStream.new(socket, @driver)

			@driver.start

			on_open if respond_to? :on_open
		rescue EOFError
			close
		end

		def read
			@message_stream.read
		end

		def closed?
			@socket.closed?
		end

		def write(msg)
			if msg.is_a? String
				@driver.text(msg)
			elsif msg.is_a? Array
				@driver.binary(msg)
			else
				raise "Can only send byte array or string over driver."
			end
		rescue IOError, Errno::ECONNRESET, Errno::EPIPE
			raise SocketError, "error writing to socket"
		end
		alias_method :<<, :write

		def close
			@driver.close unless @driver.nil?
			@socket.close unless @socket.nil? || @socket.closed?
		end

		def shutdown
			close
		end

		private

		class DriverEnvironment
			extend Forwardable

			attr_reader :env, :url, :socket

			def_delegators :socket, :write

			def initialize(env, socket)
				@env = env

				secure = ::Rack::Request.new(env).ssl?
				scheme = secure ? 'wss:' : 'ws:'
				@url = scheme + '//' + env['HTTP_HOST'] + env['REQUEST_URI']

				@socket = socket
			end
		end

		class MessageStream
			BUFFER_SIZE = 16384

			def initialize(socket, driver)
				@socket = socket
				@driver = driver
				@message_buffer = []

				@driver.on :message do |message|
					@message_buffer.push(message.data)
				end
			end

			def read
				while @message_buffer.empty?
					buffer = @socket.readpartial(BUFFER_SIZE)
					@driver.parse(buffer)
				end
				@message_buffer.shift
			end
		end
	end
end

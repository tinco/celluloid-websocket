require 'forwardable'
module Celluloid
	module IO
		# Wraps a socket as gotten from the Rack hijack API
		class RackSocket < Stream
			extend Forwardable

			def_delegators :@socket, :read_nonblock, :write_nonblock, :close, :close_read, :close_write, :closed?

			def initialize(socket)
				@socket = socket
			end

			def to_io
				@socket
			end

			# Receives a message
			def recv(maxlen, flags=nil)
				raise NotImplementedError, "flags not supported" if flags && !flags.zero?
				readpartial(maxlen)
			end

			# Send a message
			def send(msg, flags, dest_sockaddr = nil)
				raise NotImplementedError, "dest_sockaddr not supported" if dest_sockaddr
				raise NotImplementedError, "flags not supported" unless flags.zero?
				write(msg)
			end
		end
	end
end
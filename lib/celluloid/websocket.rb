require 'forwardable'
require 'websocket_parser'
require 'uri'
require 'rack/request'

module Celluloid
	class WebSocket
		extend Forwardable

		BUFFER_SIZE = 16384

		CASE_INSENSITIVE_HASH = Hash.new do |hash, key|
			hash[hash.keys.find {|k| k =~ /#{key}/i}] if key
		end

		attr_reader :socket, :env
		def_delegators :@socket, :addr, :peeraddr

		def initialize(env, socket)
			@env = env
			@socket = socket

			# TODO we expect env to match the rack standard here, which might be awkward for non-rack servers (like Reel).
			headers = CASE_INSENSITIVE_HASH.merge Hash[env.select{|k,v| k =~ /^HTTP_/}.map{|k,v| [k[5..-1].gsub('_','-'),v] }]
			req = ::Rack::Request.new(env)
			handshake = ::WebSocket::ClientHandshake.new(:get, req.url, headers)

			if handshake.valid?
				response = handshake.accept_response
				response.render(socket)
			else
				error = handshake.errors.first

				raise HandshakeError, "error during handshake: #{error}"
			end

			@parser = ::WebSocket::Parser.new

			@parser.on_close do |status, reason|
				# According to the spec the server must respond with another
				# close message before closing the connection
				@socket << ::WebSocket::Message.close.to_data
				close
			end

			@parser.on_ping do |payload|
				@socket << ::WebSocket::Message.pong(payload).to_data
			end
		end

		[:next_message, :next_messages, :on_message, :on_error, :on_close, :on_ping, :on_pong].each do |meth|
			define_method meth do |&proc|
				@parser.send __method__, &proc
			end
		end

		def read_every(n, unit = :s)
			cancel_timer! # only one timer allowed per stream
			seconds = case unit.to_s
			when /\Am/
				n * 60
			when /\Ah/
				n * 3600
			else
				n
			end
			@timer = Celluloid.every(seconds) { read }
		end
		alias read_interval  read_every
		alias read_frequency read_every

		def read(buffer_size = BUFFER_SIZE)
			@parser.append @socket.readpartial(buffer_size) until msg = @parser.next_message
			msg
		rescue
			cancel_timer!
			raise
		end

		def body
			nil
		end

		def write(msg)
			@socket << ::WebSocket::Message.new(msg).to_data
			msg
		rescue IOError, Errno::ECONNRESET, Errno::EPIPE
			cancel_timer!
			raise SocketError, "error writing to socket"
		rescue
			cancel_timer!
			raise
		end
		alias_method :<<, :write

		def closed?
			@socket.closed?
		end

		def close
			cancel_timer!
			@socket.close unless closed?
		end

		def cancel_timer!
			@timer && @timer.cancel
		end
		
		# Error occured during a WebSockets handshake
		class HandshakeError < StandardError; end
	end
end
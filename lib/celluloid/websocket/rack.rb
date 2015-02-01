require "celluloid/websocket/rack/version"
require 'reel/websocket'
require 'reel/request/info'

module Celluloid
	module Websocket
		class Rack < Reel::WebSocket
			alias_method :initialize_socket, :initialize

			def initialize
			end

			def call(env)
				env['rack.hijack'].call
				socket = env['rack.hijack_io']
				http_version = env['HTTP_VERSION'].split('/',2)[1]
				info = Reel::Request::Info.new(env.request_method, env.url, http_version, env)
				initialize_socket(info, socket)
			end
		end
	end
end

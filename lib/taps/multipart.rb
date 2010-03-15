require 'restclient'
require 'rack/utils'
require 'json'
require 'stringio'

module Taps
class Multipart
	attr_reader :opts

	def initialize(opts={})
		@opts = opts
	end

	def read
		opts[:payload]
	end

	def to_s
		opts[:payload]
	end

	def content_type
		opts[:content_type] || 'text/plain'
	end

	def original_filename
		opts[:original_filename]
	end

	def self.create(opts)
		m = RestClient::Payload::Multipart.new(opts)
		[m.to_s, m.headers['Content-Type']]
	end

	# response is a rest-client response
	def self.parse(response)
		env = {
			'CONTENT_TYPE' => response.headers[:content_type],
			'CONTENT_LENGTH' => response.headers[:content_length],
			'rack.input' => StringIO.new(response.body)
		}

		params = Rack::Utils::Multipart.parse_multipart(env)
		params.symbolize_keys!
		params
	end

end
end

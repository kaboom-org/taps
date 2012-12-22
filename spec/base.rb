require 'rubygems'
require 'bacon'
require 'rack/test'
require 'mocha/api'
require 'tempfile'

$:.unshift File.dirname(__FILE__) + "/../lib"

class Bacon::Context
	include Rack::Test::Methods
	include Mocha::API

	alias_method :old_it, :it
	def it(description)
		old_it(description) do
			mocha_setup
			yield
			mocha_verify
			mocha_teardown
		end
	end
end

RSpec.configure do |config|
    config.include Rack::Test::Methods
end

require 'taps/config'
Taps::Config.taps_database_url = "sqlite://#{Tempfile.new('test.db').path}"
Sequel.connect(Taps::Config.taps_database_url)

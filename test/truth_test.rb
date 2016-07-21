ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'bundler/setup'
require 'rack/test'
require 'src/server'

App.set :schema, File.read('schemas/sms.json')

class TruthTest < MiniTest::Test
	include Rack::Test::Methods

	def test_truth 
		assert true
	end

	def app
	  App
	end
end
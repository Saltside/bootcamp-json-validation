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

	def test_another
		get '/'
		assert last_response.ok?
	end

	def test_sms
		post '/sms' do
			assert last_response
		end
	end
end
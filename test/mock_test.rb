ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'bundler/setup'
require 'rack/test'
require 'src/server'
require 'sinatra/base'
require 'mocha/mini_test'

class AppTest < MiniTest::Test
	include Rack::Test::Methods
	
	def app
		App
	end

	def valid_number
		'+23482394'
	end

	def valid_message
		'testing!'
	end

	def test_leftout_shit

		gateway = mock
    gateway.expects(:deliver).with({

      numbers: [valid_number],
      message: valid_message
    })

    app.set :gateway, gateway

    post '/' , JSON.dump({

      message: valid_message,
      numbers: [valid_number]

    }),'CONTENT_TYPE' => 'application/json'

	end
 
	def test_valid_request
		gateway = mock
		gateway.expects(:deliver).with({
			message: valid_message,
			numbers: [ valid_number ]
		})
	
		app.set :gateway, gateway

		post('/sms', JSON.dump({
			message: valid_message, numbers: [ valid_number] 
		}), {
			'CONTENT_TYPE' => 'application/json'
		})

		assert_equal 204, last_response.status
		assert_empty last_response.body
	end

	def test_request_with_invalid_content_type
		post '/sms', message: 'hi', numbers: '1234'

		assert_equal 406, last_response.status
		assert_empty last_response.body
	end

	def test_request_with_invalid_data
		post '/sms', JSON.dump({ }), 'CONTENT_TYPE' => 'application/json'

		assert_equal 400, last_response.status
		assert_equal 'application/json', last_response.content_type

		data = JSON.load last_response.body
		refute_empty data.fetch('errors')
	end

	# def test_shit
	# 	# 1. setup preconditions (such as mocks, or external state, or test data/valid data etc)
	# 	# 2. do the shit (call the methods, create the shit, save the results)
	# 	# 3. assert shit (does the saved shit match the step 1 shit? did I get the rigtht shit?)
	# end
end
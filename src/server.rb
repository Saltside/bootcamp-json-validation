require 'bundler/setup'
require 'sinatra/base'
require 'json'
require 'json-schema'


class App < Sinatra::Base	
  # before do
  #   request.body.rewind
  #   @request_payload = JSON.parse request.body.read
  # end

  post '/' do
    data = JSON.load request.body
    settings.gateway.deliver({
      numbers: data.fetch('numbers'),
      message: data.fetch('message')
    })
    status 204
  end
	
  post '/sms' do
		request_content_type = request.content_type

		if request_content_type.start_with? 'application/json'
      data = JSON.load request.body

      errors = JSON::Validator.fully_validate(settings.schema, data)

      if errors.any?
        status 400
        content_type 'application/json'
        body(JSON.dump({
          errors: errors,
        }))
      else
        settings.gateway.deliver({
          numbers: data.fetch('numbers'),
          message: data.fetch('message')
        })

        status 204
        body nil
      end
    else
		  status 406
		  body nil
	  end
	end
end
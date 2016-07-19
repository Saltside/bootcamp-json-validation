require 'bundler/setup'
require 'sinatra/base'
require 'json'
require 'json-schema'


class App < Sinatra::Base
	get '/' do
		status 200
	end

	post '/sms' do
		request_content_type = request.content_type

		if request_content_type.start_with? 'application/json'
      data = JSON.load request.body

      errors = JSON::Validator.fully_validate(settings.schema, data)

      if errors.any?
        status 400
        body(JSON.dump({
          errors: errors,
          passed_not: request_content_type
        }))
      else
  			status 200
  			content_type 'application/json'
  			body(JSON.dump({  
          json_data_from_server: data,
          errors: errors
  	    }))
      end
    else
		  status 406
		  body nil
	  end
	end
end
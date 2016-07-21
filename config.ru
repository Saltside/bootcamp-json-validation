class FakeGateway
	def deliver(*args)
	end
end

App.set :gateway, FakeGateway.new
App.set :schema, File.read('schemas/sms.json')

run App
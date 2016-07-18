#!/usr/bin/ruby
require 'bundler/setup'
require 'net/http'
require 'json'
require "uri"

uri = URI.parse("http://localhost:9292/sms")
http = Net::HTTP.new(uri.host,uri.port)
req = Net::HTTP::Post.new(uri.path)
req.content_type = 'application/json'
req.body = JSON.dump({
  "message" => "hi this is me",
  "numbers" => ["+91828870"]
})
res = http.request(req)

puts res
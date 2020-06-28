require 'rack'
require_relative '../lib/router'
require_relative '../lib/show_exceptions'
require_relative '../app/controllers/creations_controller'

router = Router.new

#insert routes below
router.draw do
	get Regexp.new("/creations$"), CreationsController, :index
	get Regexp.new("/$"), CreationsController, :new
	get Regexp.new("/creations/new$"), CreationsController, :new
	get Regexp.new("creations/(?<id>\\d+)$"), CreationsController, :show
	post Regexp.new("/creations$"), CreationsController, :create
end

app = Proc.new do |env|
	req = Rack::Request.new(env)
	res = Rack::Response.new
	router.run(req,res)
	res.finish
end

app = Rack::Builder.new do
  use ShowExceptions
  run app
end.to_app

Rack::Server.start(
	app: app,
	Port: 3000
)

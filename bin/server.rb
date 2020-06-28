require 'rack'
require_relative '../lib/router'
require_relative '../app/controllers/words_controller'

router = Router.new

#insert routes below
router.draw do
	get Regexp.new("/$"), WordsController, :index
	post Regexp.new("/$"), WordsController, :create
end

app = Proc.new do |env|
	req = Rack::Request.new(env)
	res = Rack::Response.new
	router.run(req,res)
	res.finish
end

Rack::Server.start(
	app: app,
	Port: 3000
)

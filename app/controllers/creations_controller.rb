require_relative '../../lib/controller_base.rb'
require_relative '../models/creation.rb'

class CreationsController < ControllerBase
  # protect_from_forgery    -----TODO: Enable this

  def index
    # List all of our creations
		# render_content("Hello World - Index Pg", "text/html")
    raise "Help, abort abort!" # JUst have this here to test functionality of show_exception
  end

  def new
    # render page to select params for new creation
    
    render_content("Hello World - New Pg", "text/html")
  end

  def show
    # deisplay a specific creation based on id
    render_content("Hello World - Show Pg", "text/html")
  end

	def create
    #creates a new creation with the given params, renders the creation show page
    render_content("Hello World - Create Pg", "text/html")
	end
end

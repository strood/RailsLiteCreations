require_relative '../../lib/controller_base.rb'
require_relative '../models/creation.rb'

class CreationsController < ControllerBase
  # protect_from_forgery    -----TODO: Enable this

  def index
    # List all of our creations
    @creations = Creation.create(name: "Testy Fat Lion", owner: "George")
		render(:index)
  end

  def new
    # render page to select params for new creation

    render(:new)
  end

  def show
    # deisplay a specific creation based on id
    render_content("Hello World - Show Pg", "text/html")
  end

	def create
    #creates a new creation with the given params, renders the creation show page
    @name = params["creation"]["first-descriptor"]
    @name << params["creation"]["second-descriptor"]
    @name << params["creation"]["noun"]
    @owner_name = params["creation"]["owner"]
    @creation = Creation.new(name: @name, owner: @owner)
    # @creation.save!
    render_content("Name:#{@name}, Owner: #{@owner_name} Creation: #{@creation.name}" , "text/html")
	end
end

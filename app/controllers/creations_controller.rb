require_relative '../../lib/controller_base.rb'
require_relative '../models/creation.rb'

class CreationsController < ControllerBase
  # protect_from_forgery    -----TODO: Enable this

  def index
    # List all of our creations
    @creations = Creation.all
		render(:index)
  end

  def new
    # render page to select params for new creation
    render(:new)
  end

  def show
    # deisplay a specific creation based on id
    @creation = Creation.find(@req.path.split("/").last)
    # @creation  = Creation.find(:id)
    render(:show)
  end

	def create
    #creates a new creation with the given params, renders the creation show page

    @id = construct_creation(params)

    redirect_to("/creations/#{@id}")
	end

  private

  # constructs our creation and passes back id to be rendered
  def construct_creation(params)
    @name = params["creation"]["first-descriptor"] + " "
    @name << params["creation"]["second-descriptor"] + " "
    @name << params["creation"]["noun"]
    @owner_name = params["creation"]["owner"]
    @creation = Creation.new
    @creation.name = @name
    @creation.owner_name = @owner_name
    @creation.insert

    @creation.id
  end
end

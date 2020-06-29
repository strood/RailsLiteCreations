require_relative '../../lib/controller_base.rb'
require_relative '../models/owner.rb'

class OwnersController < ControllerBase
  # protect_from_forgery    -----TODO: Enable this

  def index
    # List all of our creations
    @owners = Owner.all
		render(:index)
  end

  def show
    # deisplay a specific creation based on id
    @owner = Owner.find(@req.path.split("/").last)
    # @creation  = Creation.find(:id)
    render(:show)
  end

	# def create
  #   #creates a new creation with the given params, renders the creation show page
  #
  #   @id = construct_creation(params)
  #
  #   redirect_to("/creations/#{@id}")
	# end
  #
  # private
  #
  # # constructs our creation and passes back id to be rendered
  # def construct_creation(params)
  #   @name = params["creation"]["first-descriptor"] + " "
  #   @name << params["creation"]["second-descriptor"] + " "
  #   @name << params["creation"]["noun"]
  #   @owner_name = params["creation"]["owner"]
  #   @creation = Creation.new
  #   @creation.name = @name
  #   @creation.owner_name = @owner_name
  #   @creation.insert
  #
  #   @creation.id
  # end
end

require_relative '../../lib/controller_base.rb'

class WordsController < ControllerBase
    def index
		render_content("Hello World", "text/html")
    end

	def create

	end
end

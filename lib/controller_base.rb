require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './flash'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params = {})
    # Take in req and res, create ivars to be used later

    @req = req
    @res = res
    @params = route_params.merge(@req.params)
    @already_built_response = false
    @@protect_from_forgery ||= false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    # Check its not already been built
    if already_built_response?
      raise error = ["Response already built"]
    else
      # Setup res for a redirect
      @res['Location'] = url
      @res.status = 302
      @already_built_response = true
      # Call session store to ensure session data stores once repsonse built
      session.store_session(@res)
    end
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    # Check its not already been built
    if already_built_response?
      raise error = ["Response already built"]
    else
      # Load res with content so we can pass on
      @res['Content-Type'] = content_type
      @res.write(content)
      @already_built_response = true
      # Call session store to ensure session data stores once repsonse built
      session.store_session(@res)
    end
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)

      # Contruct path to template file, using File methods to make flexible
      # incase we decide to publish as gem.
      path = File.dirname(__FILE__)
      template_fname = File.join(
        path, "..",
        "views", self.class.name.underscore, "#{template_name}.html.erb"
      )
      # Above leaves us with something like: (whatever path to stuff exists)
      # /home/strood/Dev/aA-projects/RailsLite/lib/../views/MyController/show.html.erb

      # Read template file, gathering each line of code
      lines = File.read(template_fname)

      # Use binding to capture controller instance vars and pass along
      #Use ERB to convert and embedded lines into the result, will be passed on
      render_content(
          ERB.new(lines).result(binding),
          'text/html'
      )
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # Expose teh flash object
  def flash
    @flash ||= Flash.new(@req)
  end


  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(action_name)
    if protect_from_forgery? && req.request_method != "GET"
      check_authenticity_token
    else
      form_authenticity_token
    end
    self.send(action_name)
    render(action_name) unless already_built_response?
  end

  # Allows developer to include the csrf token in their forms, when included will
  # link the csrf token. When submitted with the form it will verify.
  def form_authenticity_token
    @token ||= generate_authenticity_token
    res.set_cookie('authenticity_token', value: @token, path: '/')
    @token
  end

  protected

  def self.protect_from_forgery
      @@protect_from_forgery = true
  end

  private

  attr_accessor :already_built_response

  def check_authenticity_token
    cookie = @req.cookies['authenticity_token']
    unless cookie && cookie == params['authenticity_token']
      raise "Invalid authenticity token"
    end
  end

  def protect_from_forgery?
    @@protect_from_forgery
  end

  def generate_authenticity_token
    SecureRandom.urlsafe_base64(16)
  end

end


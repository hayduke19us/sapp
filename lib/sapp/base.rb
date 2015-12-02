require_relative 'routes'
require_relative 'response'
require_relative 'handler'
require_relative 'resources'
require_relative 'route_map'

require 'byebug'

module Sapp
  class Base
    # All RESTful verb methods in Sapp::Routes
    extend Routes

    # Support for Rails like resources with corresponding views
    extend Resources

    def self.call env
      byebug
      request = Rack::Request.new env

      handler   = Sapp::Handler.new request, routes
      unwrapped = handler.unwrap
      response  = Sapp::Response.new handler.status, unwrapped

      response.process_handler
    end

  end
end


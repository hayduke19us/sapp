require_relative 'routes'
require_relative 'response'
require_relative 'handler'
require_relative 'resources'
require_relative 'route_map'
require_relative 'path'

require 'byebug'

module Sapp
  class Base
    # All RESTful verb methods in Sapp::Routes
    extend Routes

    # Support for Rails like resources with corresponding views
    extend Resources

    def self.call env
      byebug
      # Create request object
      request = Rack::Request.new env

      # This is backwards a path object should be created
      # then if the path object matches a saved route
      # extract the handler
      # Create handler object for calling the Proc

      handler = Sapp::Handler.new request, routes

      # Check route exist, process response
      if route_exist? handler.verb, handler.path

        unwrapped = handler.unwrap

        response  = Sapp::Response.new handler.status, unwrapped

        response.process_handler

      else

        not_found!

      end
    end

  end
end


require_relative 'routes'
require_relative 'response'
require_relative 'handler'
require_relative 'resources'
require_relative 'route_map'

require File.expand_path('../', __FILE__) + '/path/request'

require 'byebug'

module Sapp
  class Base
    # All RESTful verb methods in Sapp::Routes
    extend Routes

    # Support for Rails like resources with corresponding views
    extend Resources

    def self.call env
      # Create request object
      request = Rack::Request.new env

      request_path = Sapp::Path::Request.new request.path, request.request_method, routes
      request_path.parse

      if request_path.path?
        handler = Sapp::Handler.new request_path.handler, request
        unwrapped = handler.unwrap

        response  = Sapp::Response.new handler.status, unwrapped

        response.process_handler

      else

        not_found!

      end
    end

  end
end


require_relative 'routes'
require_relative 'response'
require_relative 'handler'
require_relative 'resources'
require 'json'

require File.expand_path('../', __FILE__) + '/path/request'

# Order of routing operations.
# 1. Create Request.
# 2. Parse request path.
# 3. If path found unwrap handler in context of params and status.
# 4. If path not found return a 404.

module Sapp
  class Base
    # All RESTful verb methods in Sapp::Routes
    extend Routes

    # Support for Rails like resources with and CRUD methods
    extend Resources

    def self.call env
      req = Rack::Request.new env
      req_path = create_path req.path, req.request_method, routes

      if req_path.path?
        find_path req_path, req
      else
         not_found! req_path.verb, req_path.original
      end

    end

    def self.run req
      req_path = create_path req.path, req.request_method, routes

      if req_path.path?
        find_path req_path, req
      end
    end

    def self.find_path req_path, req
      handler   = Sapp::Handler.new req_path.handler, req, req_path.keys
      unwrapped = handler.unwrap
      response  = Sapp::Response.new handler.status, unwrapped

      response.process_handler
    end

    def self.create_path path, method, routes
      req_path = Sapp::Path::Request.new path, method, routes
      req_path.parse
      req_path
    end

  end
end


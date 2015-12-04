require_relative 'routes'
require_relative 'response'
require_relative 'handler'
require_relative 'resources'
require_relative 'route_map'

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

    # Support for Rails like resources with corresponding views
    extend Resources

    def self.call env
      byebug
      req = Rack::Request.new env
      req_path = Sapp::Path::Request.new req.path, req.request_method, routes
      req_path.parse

      if req_path.path?
        handler = Sapp::Handler.new req_path.handler, req, req_path.keys
        unwrapped = handler.unwrap
        response  = Sapp::Response.new handler.status, unwrapped

        response.process_handler
      else
        not_found! req_path.verb, req_path.original
      end

    end

  end
end


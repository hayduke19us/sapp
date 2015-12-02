require_relative 'routes'
require_relative 'response'
require_relative 'handler'
require_relative 'resources'

require 'byebug'

module Sapp
  class Base
    # All RESTful verb methods in Sapp::Routes
    extend Routes

    # Support for Rails like resources with corresponding views
    extend Resources

    attr_reader :routes

    def self.routes
      @routes ||= Hash.new
    end

    def self.call env
      request = Rack::Request.new env

      handler   = Sapp::Handler.new request, @routes
      unwrapped = handler.unwrap
      response  = Sapp::Response.new handler.status, unwrapped

      response.process_handler
    end

  end
end


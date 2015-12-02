require_relative 'routes'
require_relative 'response'
require_relative 'handler'

require 'byebug'

module Sapp
  class Base
    # All RESTful verb methods in Sapp::Routes
    extend Routes

    attr_reader :routes

    def self.routes
      @routes ||= Hash.new
    end

    def self.call env
      byebug
      request = Rack::Request.new env

      handler   = Sapp::Handler.new request, @routes
      unwrapped = handler.unwrap
      response  = Sapp::Response.new handler.status, unwrapped

      response.process_handler
    end

  end
end


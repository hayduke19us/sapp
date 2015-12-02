require 'byebug'
require_relative 'routes'
require_relative 'response'
require_relative 'handler'

module Sapp
  class Base
    extend Routes

    def self.routes
      @routes ||= Hash.new
    end

    def self.call env
      byebug
      @request = Rack::Request.new env

      handler  = Sapp::Handler.new @request, @routes
      response = Sapp::Response.new handler.status, handler.unwrap

      response.process_handler

    end

    private

    def self.route verb, path, &handler
      routes[verb] ||= Hash.new
      routes[verb][path] = handler
    end

  end
end


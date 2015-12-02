require 'byebug'
require_relative 'routes'

module Sapp
  class Base
    extend Routes

    def self.routes
      @routes ||= Hash.new
    end

    def self.call env
      @request = Rack::Request.new env
      verb     = @request.request_method
      path     = @request.path_info

      handler  = @routes.fetch(verb, {}).fetch(path, nil)
      handler.call
    end

    private

      def self.route verb, path, &handler
        routes[verb] ||= Hash.new
        routes[verb][path] = handler
      end

      def self.params
        @request.params
      end

      def self.status=(stat)
        @status = stat
      end

  end
end


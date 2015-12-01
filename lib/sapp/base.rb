module Sapp
  class Base

    attr_reader :routes

    def initialize
      @routes = {}
      define_verbs
    end

    def call env
      request = Rack::Request env
      verb    = request.request_method
      path    = request.path_info

      handler = @routes.fetch(verb, {}).fetch(path, nil)
      handler.call
    end

    def define_verbs
      %w(get put post patch delete).each do |v|
        self.class.create_method v
      end
    end

    private
    def self.create_method verb
      send(:define_method, verb) do |path, &handler|
        route verb, path, &handler
      end
    end

    def route verb, path, &handler
      @routes[verb] ||= {}
      @routes[verb][path] = handler
    end

  end
end

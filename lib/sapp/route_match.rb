module Sapp
  # Responsible for looking for a route match
  class RouteMatch

    attr_reader :verb, :path, :routes

    def initialize routes, verb, path
      @verb = verb
      @path = Sapp::Path.new(path).parse
      @routes = routes
    end

    def found?
      if routes[verb] && routes[verb][path]

      end
    end

  end
end

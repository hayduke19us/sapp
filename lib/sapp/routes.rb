require_relative 'route_map'

module Sapp

  # Use exclusively as a mixin for Base
  module Routes

    def route_map
      @route_map ||= RouteMap.new
    end

    def routes
      route_map.routes
    end

    def get path, &handler
      route "GET", path, &handler
    end

    def post path, &handler
      route "POST", path, &handler
    end

    def put path, &handler
      route "PUT", path, &handler
    end

    def patch path, &handler
      route "PATCH", path, &handler
    end

    def delete path, &handler
      route "DELETE", path, &handler
    end

    def head path, &handler
      route "HEAD", path, &handler
    end


    private
    def empty_proc
      @empty_proc ||= Proc.new { "Placeholder" }
    end

    def route verb, path, &handler
      routes[verb] ||= Hash.new

      if block_given?
        routes[verb][path] = handler
      else
        routes[verb][path] = empty_proc
      end
    end

  end
end


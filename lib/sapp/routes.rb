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

    def add verb, path, &handler
      route_map.add verb, path, &handler
    end

    def get path, &handler
      add "GET", path, &handler
    end

    def post path, &handler
      add "POST", path, &handler
    end

    def put path, &handler
      add "PUT", path, &handler
    end

    def patch path, &handler
      add "PATCH", path, &handler
    end

    def delete path, &handler
      add "DELETE", path, &handler
    end

    def head path, &handler
      add "HEAD", path, &handler
    end

  end
end


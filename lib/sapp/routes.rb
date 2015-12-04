require_relative 'route_map'
require_relative 'route_match'

module Sapp

  # Use exclusively as a mixin for Base
  module Routes


    def route_map
      @route_map ||= RouteMap.new
    end

    def routes
      route_map.routes
    end

    def matcher verb, path
      @matcher ||= RouteMatch.new routes, verb, path
    end

    def route_exist? verb, path
      matcher(verb, path).found?
    end

    def not_found! verb, path
      [404, {}, ["Oops! No route for #{verb} #{path}"]]
    end


    def add verb, path, &handler
      route_map.add verb, path, &handler
    end

    alias_method :route, :add

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


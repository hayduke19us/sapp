module Sapp
  class RouteMap

    attr_accessor :routes

    def initialize
      @routes = Hash.new
    end

    def empty_proc
      @empty_proc ||= Proc.new { "Placeholder" }
    end

    def add verb, path, &handler
      routes[verb] ||= Hash.new

      if block_given?
        routes[verb][path] = handler
      else
        routes[verb][path] = empty_proc
      end
    end


  end
end

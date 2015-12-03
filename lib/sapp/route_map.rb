module Sapp
  class RouteMap

    attr_accessor :routes

    def initialize
      @routes = Hash.new
    end

    def empty_proc
      @empty_proc ||= Proc.new { "Placeholder" }
    end

    # I need to extract the keys which is to say that each path has keys
    # everything is determined by the keys
    def add verb, path, &handler
      routes[verb] ||= Hash.new

      # extract keys here
      # path = Path.new path

      if block_given?
        routes[verb][path] = handler
      else
        routes[verb][path] = empty_proc
      end
    end

    def parse path
      hash = Hash.new
      x = 0

      s = path.split('/')
      s.delete ""

      s.each do |p|

        hash[x] = p
        x += 1

      end

      hash

    end


    def quick_parse path
      path.split('/').last
    end

    def remove verb, path=nil
      if path
        routes[verb].delete path
      else
        routes.delete verb
      end
    end

  end
end

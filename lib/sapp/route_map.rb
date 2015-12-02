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

    def remove verb, path=nil
      if path
        routes[verb].delete path
      else
        routes.delete verb
      end
    end

    def exist? verb, path
      @verb = verb
      @path = path

      routes[verb] && routes[verb][path]
    end

    def not_found!
      [404, {}, ["Oops! No route for #{@verb} #{@path}"]]
    end

    def parser path
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


  end

end

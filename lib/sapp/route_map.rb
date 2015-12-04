require File.expand_path('../', __FILE__) + '/path/base'

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
      path_hash = Sapp::Path::Base.new(path).parse

      verbs = get_or_create_verb verb
      controller = get_or_create_controller path_hash, verbs

      if path_exist? controller, path_hash[:original]
        update_path controller, path_hash, handler
      else
        create_set controller, path_hash, &handler
      end

    end

    def update_path controller, path_hash, handler
      controller[:paths].map do |path|
        if path[:original] == path_hash[:original]
          path = add_handler(path_hash, handler)
        end
      end
    end

    def path_exist? controller, path
      controller.any? && controller[:index].include?(path)
    end

    def create_set controller, path_hash, &handler
      get_or_create_paths controller
      get_or_create_index controller
      add_path path_hash, controller, &handler
      add_path_to_index controller, path_hash[:original]
    end

    def add_path_to_index controller, path
      controller[:index] << path
    end

    def get_or_create_verb verb
      routes[verb] ||= Hash.new
    end

    def get_or_create_controller path_hash, verbs
      controller = path_hash[:controller]
      verbs[controller] ||= Hash.new
    end

    def get_or_create_paths controller
      controller[:paths] ||= Array.new
    end

    def get_or_create_index controller
      controller[:index] ||= Array.new
    end

    def add_stream path_hash, controller
      controller[:streams] << path_hash[:stream]
    end

    def add_path path_hash, controller, &handler
      if block_given?
        controller[:paths] <<  add_handler(path_hash, handler)
      else
        controller[:paths] <<  add_handler(path_hash, empty_proc)
      end
    end

    def add_handler path_hash, handler
      path_hash.merge handler: handler
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

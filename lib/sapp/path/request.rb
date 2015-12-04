require_relative 'base'

module Sapp
  module Path
    class Request < Base

      attr_reader :routes, :verb, :handler, :keys, :path

      def initialize original, verb, routes
        super(original)
        @verb = verb
        @routes = routes
        @keys = Hash.new
        @handler = nil
      end

      # Sets controller, path keys and handler
      def parse
        byebug
        set_controller

        @path  = find_path.uniq.first
        @keys  = extract_keys(@path, sort_path)
        @handler = @path[:handler]
      end

      def match_by_stream_count
        paths.select { |p| check_stream? p, sort_path }
      end

      def match_by_methods_and_stream
        match_by_stream_count.select { |p| check_methods? p, sort_path }
      end

      # Matches by method names and stream count, returns best match
      def find_path
        if match_by_methods_and_stream.empty?
          match_by_stream_count
        else
          match_by_methods_and_stream
        end
      end

      def paths
        find_controller[:paths]
      end

      # Parses path by '/' and creates a numbered dictionary EX: { 0 => 'user' }
      def sort_path
        array = Array.new

        setup_extraction.each do |v|
          array << [counter, v]
          count
        end

        @sort_path ||= Hash[array]
      end

      def extract_keys path, hash
        h = Hash.new

        hash.each do |k, v|
          if k > 0 
            key = path[:keys][k]
            h[eval key] = v
          end
        end

        h
      end

      def find_controller
        routes[verb][controller]
      end

      def check_all? p, hash
        check_stream?(p, hash) || sort_methods(p, hash).any?
      end

      def check_stream? p, hash
        p[:stream].count == hash.values.count
      end

      def check_methods? p, hash
        (p[:methods].values - hash.values).any?
      end

      # Sets the controller based off the first key:value pair
      def set_controller 
        @controller = sort_path[0]
      end

      def path?
        @handler ? true : false
      end

    end
  end
end

require_relative 'base'

module Sapp
  module Path
    class Request < Base

      attr_reader :routes, :verb, :handler, :keys, :path

      def initialize original, verb, routes
        @original = original
        @verb = verb
        @routes = routes
        @keys = Hash.new
        @handler = nil
      end

      # Sets controller, path keys and handler
      def parse
        set_controller

        if path?
          @path  = find_path.uniq.first
          @keys  = extract_keys
          @handler = @path[:handler]
        end
      end

      # Returns hash of matched paths by stream count
      def match_by_stream_count
        paths.select { |p| check_stream? p, sort_path }
      end

      # Returns hash of matched paths by stream count and method name
      def match_by_methods_and_stream
        match_by_stream_count.select { |p| check_methods? p, sort_path }
      end

      # Matches by method names and stream count, returns best match
      def find_path
        match_by_methods_and_stream
      end

      # Return paths from request controller
      def paths
        find_controller[:paths]
      end

      # Parses path by '/' and creates a numbered dictionary EX: { 0 => 'user' }
      def sort_path
        reset_counter
        array = Array.new

        setup_extraction.each do |v|
          array << [counter, v]
          count
        end

        @sort_path ||= Hash[array]
      end

      # Remove the first key:value(controller) return a hash with keys from path
      def extract_keys
        hash = Hash.new

        sort_path.each do |k, v|
          if path[:keys].include?(k) && k > 0
            hash[extract_key(k)] = v
          end
        end

        hash
      end

      def key? k
        k > 0
      end

      def extract_key k
        key = path[:keys][k]
        key.tr(':', '').to_sym
      end

      def find_controller
        routes[verb][controller]
      end

      def check_stream? p, hash
        p[:stream].count == hash.values.count
      end

      def check_methods? p, hash
        (p[:methods].values - hash.values).empty?
      end

      # Sets the controller based off the first key:value pair
      def set_controller 
        @controller = sort_path[0]
      end

      # Returns boolean, is handler defined?
      def path?
        find_controller && find_path.any?
      end

    end
  end
end

require_relative 'base'

module Sapp
  module Path
    class Request < Base

      attr_reader :routes, :verb, :keys, :handler

      def initialize original, verb, routes
        super(original)
        @verb = verb
        @routes = routes
        @keys = Hash.new
        @handler = nil
      end

      def parse
        hash = create_hash
        set_controller hash[0]
        paths = find_controller[:paths]
        boom = []

        paths.each do |p|
          if check_stream? p, hash
            boom << p
          end
        end

        boom.each do |b|
          if check_methods? b, hash
            boom << b
          end
        end

        path = boom.uniq.first

        @keys = extract_keys path, hash
        @handler = path[:handler]
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

      def create_hash
        hash = Hash.new
        setup_extraction.each do |v|
          hash[counter] = v
          count
        end
        hash
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

      def set_controller v
        @controller = v
      end

      def path?
        @handler ? true : false
      end

    end
  end
end

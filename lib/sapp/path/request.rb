require_relative 'base'

module Sapp
  module Path
    class Request < Base

      def initialize original, verb, routes
        super(original)
        @verb = verb
        @routes = routes
      end

      def parse
        hash = create_hash
        set_controller hash[0]
      end

      def create_hash
        hash = Hash.new
        setup_extraction.each do |v|
          hash[counter] = v
          count
        end
        hash
      end

      def set_controller v
        @controller = v
      end

    end
  end
end

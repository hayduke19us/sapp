module Sapp
  module Path
    class Base
      attr_reader :original, :keys, :paths, :stream, :controller

      def initialize path
        @original = path
        @keys     = Hash.new
        @paths    = Hash.new
        @stream   = Array.new
        @controller = '/'
        @counter  = 0
      end

      def parse
        extract_keys_and_paths
        set_controller
        create_path
      end

      def setup_extraction
        x = original.split('/')
        x.delete("")
        x
      end

      def extract_keys_and_paths
        setup_extraction.each do |values|
          extract_keys values
          extract_paths values
          count
        end
      end

      def extract_keys k
        if k.match(/\A:/)
          stream << 0
          keys[counter] = k
        end
      end

      def extract_paths p
        unless p.match(/\A:/)
          stream << 1
          paths[counter] = p
        end
      end

      def create_path
        {
           controller: @controller,
           stream: stream,
           keys: keys,
           methods: paths,
           original: original
        }
      end

      def counter
        @counter
      end

      private

      def set_controller 
        if paths[0]
          @controller = paths[0]
          paths.delete 0
        else
          raise ArgumentError, "A Path can't begin with a symbol"
        end
      end

      def count
        @counter += 1
      end

      def reset_counter
        @counter = 0
      end

    end
  end
end



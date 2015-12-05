module Sapp
  module Path
    class Base
      attr_reader :original, :keys, :paths, :stream, :controller, :options

      def initialize path, options: {}
        @original   = set_original options, path
        @options    = options
        @keys       = Hash.new
        @paths      = Hash.new
        @stream     = Array.new
        @controller = '/'
        @counter    = 0
      end

      def parse
        extract_keys_and_paths
        set_controller
        path = create_path

        options? ? path.merge(options) : path
      end

      def set_original options, path
        begin
          if options[:namespaces] && options[:namespaces].count > 2
            raise ArgumentError, "Routes nested too deeply"
          else
            concat_namespace_and_path path, options[:namespaces]
          end
        end
      end

      def concat_namespace_and_path path, namespaces
        if namespaces && namespaces.any?
          x = namespace_to_path namespaces[0]
          y = namespaces[1] ? namespace_to_path(namespaces[1]) : ""

          x + path + y
        else
          path
        end
      end

      def namespace_to_path namespaces
        '/' + namespaces.join('/') 
      end

      def options?
        options.any?
      end

      def namespaces?
        options && options[:namespaces] && options[:namespaces].any?
      end

      def namespaces
        options[:namespaces]
      end

      def setup_extraction
        path = original.split('/')
        path.delete("")
        path
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
           original: original,
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



module Sapp
  module Path
    # An Object that builds a path structure for matching. Is used during
    # the addition of routes. 
    class Base
      attr_reader :original, :keys, :paths, :stream, :controller, :options

      def initialize path, options: {}
        @original   = set_original options, path
        @options    = options
        @keys       = Hash.new
        @paths      = Hash.new
        @stream     = Array.new
        @counter    = 0
      end

      def parse
        extract_keys_and_paths
        set_controller
        path = create_path

        options? ? path.merge(options) : path
      end

      def set_original options, path
        namespaces = options[:namespaces]

        begin
          if nested_deeply? namespaces 
            raise ArgumentError, "Routes nested too deeply"
          else
            concat_namespace_and_path path, namespaces
          end
        end
      end

      def nested_deeply? namespaces
        namespaces? namespaces && namespaces.count > 2
      end

      def concat_namespace_and_path path, namespaces
        if namespaces? namespaces
          x = namespace_to_path namespaces[0]
          y = nested?(namespaces) ? namespace_to_path(namespaces[1]) : ""

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

      def nested? namespaces
        namespaces[1]
      end

      def namespaces? namespaces
        namespaces && namespaces.any?
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

      def extract_keys key
        if key.match(/\A:/)
          stream << 0
          keys[counter] = key
        end
      end

      def extract_paths path
        unless path.match(/\A:/)
          stream << 1
          paths[counter] = path
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
        if @controller = paths[0]
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



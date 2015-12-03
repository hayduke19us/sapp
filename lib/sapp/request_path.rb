module Sapp
  class RequestPath

    def initialize path
      @original = path
    end

    def parse
      extract_keys_and_paths
      create_path
    end

    def setup_extraction
      x = original.split('/')
      x.delete("")
      x
    end

    def extract_keys_and_paths
      setup_extraction.each do |value|
        extract_keys value
        extract_paths value
        count
      end
    end

    def extract_keys k
      keys[counter] = k if k.match(/\A:/)
    end

    def extract_paths p
      paths[counter] = p unless p.match(/\A:/)
    end

    def key? c
      c.match(/\A:/)
    end

    def create_path
      begin

        if prefix_is_controller? paths[0]
          {controller: paths[0], keys: keys, methods: paths }
        else
          raise ArgumentError, "A Path can't begin with a symbol"
        end

      end
    end

    def counter
      @counter
    end

    private

    def prefix_is_controller? path
      path[0].match(/\A^:/) ? false : true
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
end

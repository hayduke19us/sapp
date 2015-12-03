module Sapp
  class Path

    attr_reader :original, :keys, :paths

    def initialize path
      @original = path
      @keys     = Hash.new
      @paths    = Hash.new
      @counter  = 0
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
      setup_extraction.each do |values|
        extract_keys values
        extract_paths values
        count
      end
    end

    def extract_keys k
      keys[counter] = k if k.match(/\A:/)
    end

    def extract_paths p
      paths[counter] = p unless p.match(/\A:/)
    end

    def create_path
      {keys: keys, paths: paths}
    end



    def counter
      @counter
    end

    private

    def count
      @counter += 1
    end

    def reset_counter
      @counter = 0
    end


  end
end

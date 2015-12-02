module Sapp

  # Use exclusively as a mixin for Base
  module Routes

    VERBS = %w(GET PUT PATCH POST DELETE HEAD)

    def get(path, &handler)
      route("GET", path, &handler)
    end

    def post(path, &handler)
      route("POST", path, &handler)
    end

    def put(path, &handler)
      route("PUT", path, &handler)
    end

    def patch(path, &handler)
      route("PATCH", path, &handler)
    end

    def delete(path, &handler)
      route("DELETE", path, &handler)
    end

    def head(path, &handler)
      route("HEAD", path, &handler)
    end

    def resources name
      empty_proc = Proc.new { "This is a place holder for #{name}"}
      route "GET", "/#{name}s", &empty_proc
    end

    def index name, &block
      route "GET", "/#{name}", &block
    end

    def parse_controller_name
      self.name.split(/(?=[A-Z])/).first.downcase
    end

    private
    def route verb, path, &handler
      routes[verb] ||= Hash.new
      routes[verb][path] = handler
    end

  end
end


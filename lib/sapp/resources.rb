module Sapp
  module Resources

    def resources name
      add "GET", "/#{name}s"
      add "GET", "/#{name}/:id"
      add "POST", "/#{name}"
      add "PATCH", "/#{name}/:id"
      add "DELETE", "/#{name}/:id"
    end

    def index name, &block
      add "GET", "/#{name}", &block
    end

    def show name, &block
      add "GET", "/#{name}/:id", &block
    end

    def update name, &block
      add "PATCH", "/#{name}/:id", &block
    end

    def create name, &block
      add "POST", "/#{name}", &block
    end

    def destroy name, &block
      add "DELETE", "/#{name}", &block
    end

  end
end

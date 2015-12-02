module Sapp
  module Resources

    def resources name
      route "GET", "/#{name}s"
      route "GET", "/#{name}"
      route "POST", "/#{name}"
      route "PATCH", "/#{name}/:id"
      route "DELETE", "/#{name}/:id"
    end

    def index name, &block
      route "GET", "/#{name}", &block
    end

    def show name, &block
      route "GET", "/#{name}", &block
    end

    def update name, &block
      route "PATCH", "/#{name}/:id", &block
    end

    def create name, &block
      route "POST", "/#{name}", &block
    end

    def destroy name, &block
      route "DELETE", "/#{name}", &block
    end

  end
end

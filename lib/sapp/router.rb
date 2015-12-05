module Sapp
  class Router

    def initialize &block
      @apps = Array.new
      instance_eval(&block) if block
    end

    def call env
      byebug
      request = Rack::Request.new env
      found   = Array.new

      @apps.each do |a|
        path = a.run(request)
        found << path if path
      end

      found.any? ? found.first : [ 404, {}, "Not found" ]
    end

    def apps
      @apps
    end

    private
    def create app
      @apps << app
    end

  end
end

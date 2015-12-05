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

      begin
        duplicate_apps! if found.count > 1
      rescue => e
        puts e.message
        found.any? ? found.first : [ 404, {}, "Not found" ]
      end

    end

    def duplicate_apps! 
      raise %[
        It seems you have multiple applications, with duplicate
        routes.

        --> Apps: #{apps.join(', ')}

        Check those classes, and remove duplicate routes.
      ]
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

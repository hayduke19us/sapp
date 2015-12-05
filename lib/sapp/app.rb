module Sapp
  class Router

    def initialize &block
      @apps = Array.new
      instance_eval(&block) if block
    end

    def call env
      @apps.each do |a|
        path = a.call env
        path ? path : [ 404, {}, "Not found" ]
      end
    end

    def create app
      @apps << app
    end

  end
end

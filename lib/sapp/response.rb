module Sapp
  class Response

    attr_reader :routes, :verb, :path

    def initialize params, status=nil
      @params = params
      @status = status
    end

    def finish
      if route_exist?
        result = instance_eval(&handler)
        process_result result
      else
        [404, {}, ["Oops! No route for #{verb} #{path}"]]
      end
    end

    def route_exist?
      @routes[verb] && handler  ? true : false
    end

    private

    def process_result result
      case result.class
        when String
          create_tuple 200, result
        when Array
          result
        when Hash
          create_tuple 200, result.to_json
        else
          [500, {}, ["response must be a string, tuple, or hash"]]
      end
    end

    def create_tuple status, body
      set_status status
      [@status, {}, body]
    end

    def set_status
      @status ||= status
    end

    def handler
      @routes[verb][path]
    end
  end

end

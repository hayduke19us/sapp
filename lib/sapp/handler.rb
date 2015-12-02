module Sapp

  # In charge of checking for a route match and
  # setting the status, contains the unwrap method
  # to call the handler proc in the context of this class.
  # We need access to #params and #status
  class Handler

    attr_reader :routes, :verb, :path, :status

    def initialize request, routes
      @request = request
      @routes  = routes
      @verb    = @request.request_method
      @path    = @request.path
      @status  = nil
    end

    def unwrap
      if route_exist?
        instance_eval(&handler)
      else
        [404, {}, ["Oops! No route for #{verb} #{path}"]]
      end
    end

    def route_exist?
      routes[verb] && handler  ? true : false
    end

    private

    def handler
      routes[verb][path]
    end

    def params
      @request.params
    end

    def status=(code)
      @status = code
    end
  end
end

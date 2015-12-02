module Sapp

  # In charge of checking for a route match and
  # setting the status, contains the unwrap method
  # to call the handler proc in the context of this class.
  # We need access to #params and #status
  class Handler

    attr_reader :verb, :path, :status, :routes

    def initialize request, routes
      @request = request
      @routes  = routes
      @verb    = @request.request_method
      @path    = @request.path
      @status  = nil
    end

    def unwrap
      instance_eval(&handler)
    end

    private

    def handler
      routes[verb][path]
    end

    def params
      @request.params
    end

    def set_status code
      @status = code
    end
  end
end

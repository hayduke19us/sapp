module Sapp

  # In charge of checking for a route match and
  # setting the status, contains the unwrap method
  # to call the handler proc in the context of this class.
  # We need access to #params and #status
  class Handler

    def initialize handler, request, keys
      @handler = handler
      @request = request
      @keys    = keys
    end

    def unwrap
      add_keys_to_params
      instance_eval(&handler)
    end

    def status
      @status
    end

    private

    def add_keys_to_params
      params.merge! keys
    end

    def params
      @request.params
    end

    def set_status code
      @status = code
    end

    def handler
      @handler 
    end

    def keys
      @keys
    end

  end
end

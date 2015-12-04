module Sapp

  # In charge of checking for a route match and
  # setting the status, contains the unwrap method
  # to call the handler proc in the context of this class.
  # We need access to #params and #status
  class Handler

    def initialize handler
      @handler = handler
    end

    def unwrap
      instance_eval(&handler)
    end

    def status
      @status
    end

    private

    def params
      @request.params
    end

    def set_status code
      @status = code
    end

    def handler
      @handler 
    end

  end
end

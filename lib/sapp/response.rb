module Sapp

  # In charge of creating the tuple
  # deciding content-type and
  # raising errors 
  class Response

    attr_reader :handler, :status

    def initialize status, handler
      @status  = status
      @handler = handler
    end

    # With defaults
    def process_handler
      case handler
        when String
          create_tuple 200, handler
        when Array
          handler
        when Hash
          create_tuple 200, handler.to_json
        else
          [500, {}, ["response must be a string, tuple, or hash"]]
      end
    end

    private

    # If status at initialization use, else use default
    def create_tuple default_status, body
      [status ? status : default_status, {}, body]
    end

  end
end

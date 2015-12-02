module Sapp

  # In charge of creating the tuple
  # deciding Content-Type and returning status.
  class Response

    attr_reader :handler, :status, :headers

    def initialize status, handler
      @status  = status
      @handler = handler
      @headers = Hash.new
    end

    # With defaults
    def process_handler
      case handler
        when String
          create_tuple 200, handler
        when Array
          handler
        when Hash
          add_header 'Content-Type', 'application/json' 
          create_tuple 200, handler.to_json
        else
          [500, {}, ["response must be a string, tuple, or hash"]]
      end
    end

    private

    def add_header key, value
      @headers[key] = value
    end

    # If status at initialization use, else use default
    def create_tuple default_status, body
      [status ? status : default_status, headers, body ]
    end

  end
end

require 'byebug'

module Sapp
  class Base

    def self.routes
      @routes ||= Hash.new
    end

    def self.call env
      @request = Rack::Request.new env
      verb     = @request.request_method
      path     = @request.path_info

      handler  = @routes.fetch(verb, {}).fetch(path, nil)
      handler.call
    end

    def self.define_verbs
      %w(get put post patch delete).each do |v|
        create_method v
      end
    end

    private

      def self.create_method verb
        send(:define_singleton_method, verb) do |path, &handler|
          route verb.upcase, path, &handler
        end
      end

      def self.route verb, path, &handler
        routes[verb] ||= Hash.new
        routes[verb][path] = handler
      end

      def self.params
        @request.params
      end

      def self.status=(stat)
        @status = stat
      end

      define_verbs
  end
end


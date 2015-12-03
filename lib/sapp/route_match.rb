module Sapp
  # Responsible for looking for a route match
  class RouteMatch

    attr_reader :verb, :path, :routes

    def initialize routes, verb, path
      @verb = verb
      @path = path
      @routes = routes
    end

    def found?
      routes[verb] && routes[verb][path]
    end

    private

    def parse path
      hash = Hash.new
      x = 0

      s = path.split('/')
      s.delete ""

      s.each do |p|

        hash[x] = p
        x += 1

      end

      hash

    end

    def pattern segment
      segment.to_str.gsub(/[^\?\%\\\/\:\*\w]|:(?!\w)/) do |c|
        ignore << escaped(c).join if c.match(/[\.@]/)
        patt = encoded(c)
        patt.gsub(/%[\da-fA-F]{2}/) do |match|
          match.split(//).map! {|char| char =~ /[A-Z]/ ? "[#{char}#{char.tr('A-Z', 'a-z')}]" : char}.join
        end
      end
    end

    def something
      patterns = []
      segments = path.split('/', -1).map!

      segments.each do |s|
        patterns << pattern(s)
      end
    end

  end
end

module StringExpansion
  class << self
    def apply(string)
      compile(parse(string)).flatten
    end

    private

    def parse(string)
      parsers = PatternParser.parsers

      string.split(/(\[[^\]]+\])/).map do |s|
        (parsers.find {|p| s =~ p.pattern } || StraightParser).parse(s)
      end
    end

    def compile(array)
      return array if array.size <= 1
      a1, a2 = array.shift(2)
      a3 = a1.flat_map {|x| a2.map {|y| [x, y].join }}
      compile(array.unshift(a3))
    end
  end

  module SimpleRangeParseAction
    def prepare(a, b)
      [a, b]
    end

    def parse(string)
      string =~ @pattern
      a, b = prepare($1, $2)
      a < b ? (a..b).to_a : (b..a).to_a.reverse
    end
  end

  module PatternParser
    def self.parsers
      constants.map {|nm| const_get(nm) }
    end

    def pattern(pattern=nil)
      return @pattern unless pattern
      @pattern = pattern
    end

    module NaturalNumberRangeParser
      extend PatternParser
      extend SimpleRangeParseAction
      pattern(/\[(\d+)-(\d+)\]/)

      def self.prepare(*args)
        return args.map(&:to_i) unless args.any? {|s| s[0] == '0' }

        len = args.map(&:length)
        fmt = "%0#{len.max}d"
        len[0] == len[1] ? args : args.map {|s| fmt % s.to_i }
      end
    end

    module SimpleAlphabetRangeParser
      extend PatternParser
      extend SimpleRangeParseAction
      pattern(/\[([a-zA-Z]+)-([a-zA-Z]+)\]/)

      def self.prepare(a, b)
        a.downcase == a ? [a, b.downcase] : [a, b.upcase]
      end
    end
  end

  module StraightParser
    def self.parse(string)
      [string]
    end
  end

  refine String do
    def expand
      StringExpansion.apply(self)
    end
  end
end

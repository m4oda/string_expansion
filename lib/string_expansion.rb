module StringExpansion
  class << self
    def apply(string)
      compile(parse(string))
    end

    private

    def parse(string)
      parsers = PatternParser.parsers

      string.split(/((?<!\\)\[[^\]]+(?<!\\)\])/).map do |s|
        (parsers.find {|p| s =~ p.pattern } || StraightParser).
          parse(s, Regexp.last_match)
      end
    end

    def compile(array)
      return array.flatten if array.size <= 1
      a1, a2 = array.shift(2)
      a3 = a1.flat_map {|x| a2.map {|y| [x, y].join }}
      compile(array.unshift(a3))
    end
  end

  module SimpleRangeParseAction
    def prepare(matches)
      matches[1, 2]
    end

    def parse(string, matches)
      a, b = prepare(matches)
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

      def self.prepare(matches)
        items = matches[1, 2]
        return items.map(&:to_i) unless items.any? {|s| s[0] == '0' }

        len = items.map(&:length)
        fmt = "%0#{len.max}d"
        len[0] == len[1] ? items : items.map {|s| fmt % s.to_i }
      end
    end

    module SimpleAlphabetRangeParser
      extend PatternParser
      extend SimpleRangeParseAction
      pattern(/\[([a-z]+)-([a-z]+)\]|\[([A-Z]+)-([A-Z]+)\]/)

      def self.prepare(matches)
        matches[1, 4].compact
      end
    end
  end

  module StraightParser
    def self.parse(string, _)
      [string.gsub(/\\[\[\]]/) {|b| b[-1] }]
    end
  end

  refine String do
    def expand
      StringExpansion.apply(self)
    end
  end
end

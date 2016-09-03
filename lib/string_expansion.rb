module StringExpansion
  class << self
    def apply(string)
      compile(parse(string)).flatten
    end

    private

    def parse(string)
      parsers = PatternParser.parsers

      string.split(/(\[[^\]]+\])/).map do |s|
        (parsers.find {|p| s =~ p.pattern } || StraightParser).compile(s)
      end
    end

    def compile(array)
      return array if array.size <= 1
      a1, a2 = array.shift(2)
      a3 = a1.flat_map {|x| a2.map {|y| [x, y].join }}
      compile(array.unshift(a3))
    end
  end

  module SimpleRangeCompiler
    def compile(string)
      string =~ @pattern
      a, b = [$1, $2]
      a, b = yield(a, b) if block_given?
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
      extend SimpleRangeCompiler
      pattern(/\[(\d+)-(\d+)\]/)
    end

    module SimpleAlphabetRangeParser
      extend PatternParser
      extend SimpleRangeCompiler
      pattern(/\[([a-zA-Z]+)-([a-zA-Z]+)\]/)

      def self.compile(string)
        super do |a, b|
          a.downcase == a ? [a, b.downcase] : [a, b.upcase]
        end
      end
    end
  end

  module StraightParser
    def self.compile(string)
      [string]
    end
  end

  refine String do
    def expand
      StringExpansion.apply(self)
    end
  end
end

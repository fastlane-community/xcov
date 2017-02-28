module Xcov
  class Line

    attr_reader :execution_count
    attr_reader :executable
    attr_reader :ranges

    def initialize(execution_count, executable, ranges = nil)
      @execution_count = execution_count
      @executable = executable
      @ranges = ranges
    end

    def covered?
      execution_count > 0
    end

    # Class methods

    def self.map(dictionary)
      ranges = map_ranges(dictionary["ranges"])
      Line.new(dictionary["executionCount"], dictionary["executable"], ranges)
    end

    def self.map_ranges(dictionaries)
      return nil if dictionaries.nil?
      dictionaries.map { |dictionary| Range.map(dictionary) }
    end

  end
end

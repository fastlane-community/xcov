module Xcov
  class Range

    attr_reader :execution_count
    attr_reader :location
    attr_reader :length

    def initialize(execution_count, location, length)
      @execution_count = execution_count
      @location = location
      @length = length
    end

    # Class methods

    def self.map(dictionary)
      Range.new(
        dictionary["executionCount"],
        dictionary["location"],
        dictionary["length"]
      )
    end

  end
end

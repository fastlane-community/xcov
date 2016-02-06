
module Xcov
  class Report

    attr_accessor :coverage
    attr_accessor :targets

    def initialize (targets)
      @targets = targets
      @coverage = average_coverage(targets)
    end

    def average_coverage targets
      coverage = 0
      targets.each do |target|
        coverage = coverage + target.coverage
      end
      coverage / targets.count
    end

    def print_description
      puts "Total coverage: (#{@coverage})"

      @targets.each do |target|
        target.print_description
      end
    end

    # Class methods

    def self.map dictionary
      targets = dictionary["targets"].map { |target| Target.map(target)}

      Report.new(targets)
    end

  end
end

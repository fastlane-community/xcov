require 'target'

module Xcov
  class Report

    attr_accessor :coverage
    attr_accessor :targets

    def initalize (coverage, targets)
      @targets = targets
      @coverage = average_coverage(targets)
    end

    def average_coverage targets
      coverage = 0
      targets.each do |target|
        coverage += target.coverage
      end
      coverage * targets.count
    end

    # Class methods

    def self.map dictionary
      targets = dictionary["targets"].map { |target| Target.map(target)}

      Report.new(coverage, targets)
    end

  end
end

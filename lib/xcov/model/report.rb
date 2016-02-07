
module Xcov
  class Report < Xcov::Base

    attr_accessor :coverage
    attr_accessor :targets
    attr_accessor :target_templates

    def initialize (targets)
      @targets = targets
      @coverage = average_coverage(targets)
      @displayable_coverage = self.create_displayable_coverage
      @coverage_color = self.create_coverage_color
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

    def html_value
      @target_templates = ""
      @targets.each do |target|
        @target_templates << target.html_value
      end

      Function.template("report").result(binding)
    end

    # Class methods

    def self.map dictionary
      targets = dictionary["targets"]
        .select { |target| !target["name"].include?(".xctest") }
        .map { |target| Target.map(target)}

      Report.new(targets)
    end

  end
end

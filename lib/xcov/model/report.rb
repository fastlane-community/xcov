
module Xcov
  class Report < Xcov::Base

    attr_accessor :coverage
    attr_accessor :targets
    attr_accessor :summary
    attr_accessor :target_templates

    def initialize(targets)
      @targets = targets
      @coverage = average_coverage(targets)
      @displayable_coverage = self.create_displayable_coverage
      @coverage_color = self.create_coverage_color
      @summary = self.create_summary
    end

    def average_coverage targets
      return 0 if targets.count == 0
      return targets.first.coverage if targets.count == 1

      acc_coverage = targets.reduce(0) { |acc, target| acc + target.coverage }
      acc_coverage.to_f / targets.count
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

    def markdown_value
      "#{@targets.map { |target| target.markdown_value }.join("")}\n> Powered by [xcov](https://github.com/nakiostudio/xcov)"
    end

    def json_value
        {
          "coverage" => @coverage,
          "targets" => @targets ? @targets.map{ |target| target.json_value } : []
        }
    end

    # Class methods

    def self.map(dictionary)
      targets = Report.filter_targets dictionary["targets"]

      # Create target objects
      targets = targets.map { |target| Target.map(target) }.sort { |lhs, rhs| lhs.name <=> rhs.name }

      Report.new(targets)
    end

    def self.filter_targets(targets)
      filtered_targets = Array.new(targets)
      filtered_targets = filtered_targets.select { |target| !target["name"].include?(".xctest") } if !Xcov.config[:include_test_targets]

      if Xcov.config[:exclude_targets]
        filtered_targets = filtered_targets.select { |target| !self.excluded_targets.include?(target["name"])}
      end

      if Xcov.config[:include_targets]
        filtered_targets = filtered_targets.select { |target| self.included_targets.include?(target["name"])}
      end

      supported_targets = Xcov.project.targets
      if Xcov.config[:only_project_targets] && !supported_targets.empty?
        filtered_targets = filtered_targets.select do |target|
          name = target["name"]
          name.slice! File.extname(name) # remove target extensions
          supported_targets.include?(name)
        end
      end

      filtered_targets
    end

    def self.excluded_targets
      excluded_targets = Array.new()

      if Xcov.config[:exclude_targets]
        if Xcov.config[:exclude_targets].is_a?(Array)
          excluded_targets = Xcov.config[:exclude_targets]
        else
          excluded_targets = Xcov.config[:exclude_targets].split(/\s*,\s*/)
        end
      end

      excluded_targets
    end

    def self.included_targets
      included_targets = Array.new()

      if Xcov.config[:include_targets]
        if Xcov.config[:include_targets].is_a?(Array)
          included_targets = Xcov.config[:include_targets]
        else
          included_targets = Xcov.config[:include_targets].split(/\s*,\s*/)
        end
      end

      included_targets
    end

  end
end

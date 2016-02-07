require 'erb'

module Xcov
  class Base

    attr_accessor :name
    attr_accessor :coverage
    attr_accessor :displayable_coverage
    attr_accessor :coverage_color

    def create_displayable_coverage
      "%.0f%%" % [(@coverage*100)]
    end

    def create_coverage_color
      if @coverage > 0.8
        return "#1fcb32"
      elsif @coverage > 0.65
        return "#fcff00"
      elsif @coverage > 0.5
        return "#ff9c00"
      else
        return "#ff0000"
      end
    end

    # Class methods
    def self.template(name)
      ERB.new(File.read(File.join(File.dirname(__FILE__), "../../../views/", "#{name}.erb")))
    end

  end
end

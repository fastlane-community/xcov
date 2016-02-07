require 'erb'

module Xcov
  class Base

    attr_accessor :name
    attr_accessor :coverage
    attr_accessor :displayable_coverage

    def create_displayable_coverage
      "%.0f%%" % [(@coverage*100)]
    end

    # Class methods
    def self.template(name)
      ERB.new(File.read(File.join(File.dirname(__FILE__), "../../../views/", "#{name}.erb")))
    end

  end
end

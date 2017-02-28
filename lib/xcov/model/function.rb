require 'cgi'

module Xcov
  class Function < Xcov::Base

    def initialize(name, coverage)
      @name = CGI::escapeHTML(name)
      @coverage = coverage
      @displayable_coverage = self.create_displayable_coverage
      @coverage_color = self.create_coverage_color
    end

    def print_description
      puts "\t\t\t#{@name} (#{@displayable_coverage})"
    end

    def html_value
      Function.template("function").result(binding)
    end

    def json_value
      {
        "name" => @name,
        "coverage" => @coverage,
      }
    end

    # Class methods

    def self.map(dictionary)
      Function.new(dictionary["name"], dictionary["coverage"])
    end

  end
end

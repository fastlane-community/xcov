
module Xcov
  class Source

    attr_accessor :name
    attr_accessor :coverage
    attr_accessor :functions

    def initialize (name, coverage, functions)
      @name = name
      @coverage = coverage
      @functions = functions
    end

    def print_description
      puts "\t\t#{@name} (#{@coverage})"

      @functions.each do |function|
        function.print_description
      end
    end

    # Class methods

    def self.map dictionary
      name = dictionary["name"]
      coverage = dictionary["coverage"]
      functions = dictionary["functions"].map { |function| Function.map(function)}

      Source.new(name, coverage, functions)
    end

  end
end

require 'function'

module Xcov
  class Source

    attr_accessor :name
    attr_accessor :coverage
    attr_accessor :functions

    def initalize (name, coverage, functions)
      @name = name
      @coverage = coverage
      @functions = functions
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


module Xcov
  class Function

    attr_accessor :name
    attr_accessor :coverage

    def initialize (name, coverage)
      @name = name
      @coverage = coverage
    end

    def print_description
      puts "\t\t\t#{@name} (#{@coverage})"
    end

    # Class methods

    def self.map dictionary
      Function.new(dictionary["name"], dictionary["coverage"])
    end

  end
end

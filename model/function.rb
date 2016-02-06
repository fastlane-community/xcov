
module Xcov
  class Function

    attr_accessor :name
    attr_accessor :coverage

    def initalize (name, coverage)
      @name = name
      @coverage = coverage
    end

    # Class methods

    def self.map dictionary
      Function.new(dictionary["coverage"], dictionary["name"])
    end

  end
end

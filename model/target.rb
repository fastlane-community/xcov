require 'source'

module Xcov
  class Target

    attr_accessor :name
    attr_accessor :coverage
    attr_accessor :files

    def initalize (name, coverage, files)
      @name = name
      @coverage = coverage
      @files = files
    end

    # Class methods

    def self.map dictionary
      name = dictionary["name"]
      coverage = dictionary["coverage"]
      files = dictionary["files"].map { |file| Source.map(file)}

      Target.new(name, coverage, files)
    end

  end
end

require 'cgi'

module Xcov
  class Target < Xcov::Base

    attr_accessor :name
    attr_accessor :coverage
    attr_accessor :files
    attr_accessor :file_templates

    def initialize (name, coverage, files)
      @name = CGI::escapeHTML(name)
      @coverage = coverage
      @files = files
      @displayable_coverage = self.create_displayable_coverage
      @coverage_color = self.create_coverage_color
      @id = Digest::SHA1.hexdigest(name)
    end

    def print_description
      puts "\t#{@name} (#{@coverage})"
      @files.each do |file|
        file.print_description
      end
    end

    def html_value
      @file_templates = ""
      @files.each do |file|
        @file_templates << file.html_value
      end

      Function.template("target").result(binding)
    end

    # Class methods

    def self.map (dictionary)
      name = dictionary["name"]
      coverage = dictionary["coverage"]
      files = dictionary["files"].map { |file| Source.map(file)}

      Target.new(name, coverage, files)
    end

  end
end

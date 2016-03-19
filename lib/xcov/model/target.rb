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
      @id = Target.create_id(name)
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
      files = dictionary["files"].map { |file| Source.map(file)}
      files = files.sort! { |lhs, rhs| lhs.coverage <=> rhs.coverage }
      coverage = Target.calculate_coverage(files)

      Target.new(name, coverage, files)
    end

    def self.calculate_coverage (files)
      coverage = 0
      non_ignored_files = files.select { |file| !file.ignored }
      non_ignored_files.each { |file| coverage += file.coverage }
      coverage = coverage / non_ignored_files.count unless non_ignored_files.empty?

      coverage
    end

  end
end

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

    def markdown_value
      markdown = "## Current coverage for #{@name} is `#{@displayable_coverage}`\n"
      return markdown << "✅ *No files affecting coverage found*\n\n---\n" if @files.empty?
      markdown << "Files changed | - | - \n--- | --- | ---\n"
      markdown << "#{@files.map { |file| file.markdown_value }.join("")}\n---\n"

      markdown
    end

    def json_value
      {
        "name" => @name,
        "coverage" => @coverage,
        "files" => @files ? @files.map{ |file| file.json_value } : []
      }
    end

    # Class methods

    def self.map (dictionary)
      name = dictionary["name"]
      files = dictionary["files"].map { |file| Source.map(file)}
      files = files.sort &by_coverage_with_ignored_at_the_end
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

    def self.by_coverage_with_ignored_at_the_end
      lambda { |lhs, rhs|
        if lhs.ignored == rhs.ignored
          # sort by coverage if files are both ignored
          # or none of them are ignored
          (lhs.coverage <=> rhs.coverage)
        else
          # ignored files will come at the end
          (lhs.ignored ? 1:0) <=> (rhs.ignored ? 1:0)
        end
      }
    end

  end
end

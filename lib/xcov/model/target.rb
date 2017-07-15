require 'cgi'

module Xcov
  class Target < Xcov::Base

    attr_accessor :name
    attr_accessor :executable_lines # number of executable lines in target
    attr_accessor :covered_lines # number of covered lines in target
    attr_accessor :files
    attr_accessor :file_templates

    def initialize(name, executable, covered, files)
      @name = CGI::escapeHTML(name)
      @executable_lines = executable
      @covered_lines = covered
      @files = files
      # we cast to floats because integers always return 0
      @coverage = executable == 0 ? 0.0 : covered.to_f / executable # avoid ZeroDivisionError
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

    def self.map(dictionary)
      name = dictionary["name"]
      files = dictionary["files"].map { |file| Source.map(file)}
      files = files.sort &by_coverage_with_ignored_at_the_end

      non_ignored_files = Target.select_non_ignored_files(files)
      executable = Target.calculate_number_of_executable_lines(non_ignored_files)
      covered = Target.calculate_number_of_covered_lines(non_ignored_files)

      Target.new(name, executable, covered, files)
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

    def self.select_non_ignored_files(files)
      files.select { |file| !file.ignored }
    end

    def self.calculate_number_of_covered_lines(files)
      return 0 if files.nil? || files.empty?

      files.reduce(0) do |partial_result, file|
        partial_result + file.number_of_covered_lines
      end
    end

    def self.calculate_number_of_executable_lines(files)
      return 0 if files.nil? || files.empty?

      files.reduce(0) do |partial_result, file|
        partial_result + file.number_of_executable_lines
      end
    end

  end
end

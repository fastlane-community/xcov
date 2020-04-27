require 'cgi'

module Xcov
  class Target < Xcov::Base

    attr_accessor :name
    attr_accessor :files
    attr_accessor :file_templates

    def initialize(name, files)
      @name = CGI::escapeHTML(name)
      @files = files
      totalCoveredLines = files.reduce(0) { |acc, file| acc + file.coveredLines }
      totalExecutableLines = files.reduce(0) { |acc, file| acc + file.executableLines }
      @coverage = files.count == 0 || totalExecutableLines == 0 ? 0.0 : totalCoveredLines.to_f / totalExecutableLines.to_f
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

    def markdown_summary_value
      markdown = "## #{@name} | `#{@displayable_coverage}` | #{coverage_emoji}\n"
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

      Target.new(name, non_ignored_files)
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

  end
end

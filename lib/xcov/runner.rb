require 'pty'
require 'open3'
require 'fileutils'
require 'terminal-table'
require 'xcov-core'
require 'pathname'
require 'json'

module Xcov
  class Runner

    def run
      report_json = parse_xccoverage
      generate_xcov_report(report_json)
    end

    def parse_xccoverage
      # Find .xccoverage file
      product_builds_path = Pathname.new(Xcov.project.default_build_settings(key: "SYMROOT"))
      test_logs_path = product_builds_path.parent.parent + "Logs/Test/"
      xccoverage_files = Dir["#{test_logs_path}*.xccoverage"].sort_by { |filename| File.mtime(filename) }

      unless test_logs_path.directory? && !xccoverage_files.empty?
        ErrorHandler.handle_error("CoverageNotFound")
      end

      Xcov::Core::Parser.parse(xccoverage_files.first)
    end

    def generate_xcov_report report_json
      Report.map(report_json).print_description

      # Post result
      # SlackPoster.new.run(result)

      # How to print output
      # puts Terminal::Table.new({
      #   title: "Test Results",
      #   rows: [
      #     ["Number of tests", result[:tests]],
      #     ["Number of failures", failures_str]
      #   ]
      # })
      # puts ""

      # Stuff to do in case of failure
      # raise "Tests failed" unless result[:failures] == 0
    end

  end
end

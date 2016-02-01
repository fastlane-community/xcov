require 'pty'
require 'open3'
require 'fileutils'
require 'tempfile'
require 'terminal-table'
require 'xcov-core'
require 'pathname'

module Xcov
  class Runner
    def run
      parse_xccoverage
      generate_report
    end

    def parse_xccoverage
      product_builds_path = Pathname.new(Xcov.project.default_build_settings(key: "SYMROOT"))
      test_logs_path = product_builds_path.parent.parent + "Logs/Test/"
      xccoverage_files = Dir["#{test_logs_path}*.xccoverage"].sort_by { |filename| File.mtime(filename) }

      unless test_logs_path.directory? && !xccoverage_files.empty?
        ErrorHandler.handle_error("CoverageNotFound")
      end

      report_output = Tempfile.new("report.json")
      command = "#{ENV['XCOV_CORE_LIBRARY_PATH']} -s #{xccoverage_files.first} -o #{report_output.path}"
      prefix_hash = [{ prefix: "Parsing .xccoverage file: " }]

      FastlaneCore::CommandExecutor.execute(command: command,
                                          print_all: true,
                                      print_command: true,
                                             prefix: prefix_hash,
                                            loading: "Loading...",
                                              error: proc do |error_output|
                                                begin
                                                  ErrorHandler.handle_error(error_output)
                                                rescue => ex
                                                  SlackPoster.new.run({
                                                    build_errors: 1
                                                  })
                                                  raise ex
                                                end
                                              end)
    end

    def generate_report
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

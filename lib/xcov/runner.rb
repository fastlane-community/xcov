require 'pty'
require 'open3'
require 'fileutils'
require 'terminal-table'

module Xcov
  class Runner
    def run
      parse_xccoverage
      generate_report
    end

    def parse_xccoverage
      command = ""
      prefix_hash = [
        {
          prefix: "Parsing .xccoverage file: "
        }
      ]
      FastlaneCore::CommandExecutor.execute(command: command,
                                          print_all: true,
                                      print_command: true,
                                             prefix: prefix_hash,
                                            loading: "Loading...",
                                              error: proc do |error_output|
                                                begin
                                                  ErrorHandler.handle_build_error(error_output)
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

require 'xcov-core/version'
require 'xcov'
require 'json'
require 'fileutils'
require 'tempfile'
require 'fastlane_core'

module Xcov
  module Core

    ENV['XCOV_CORE_BINARY_PATH'] = File.expand_path("../xcov-core/bin", __FILE__) + "/xcov-core"
    ENV['XCOV_CORE_LEGACY_BINARY_PATH'] = File.expand_path("../xcov-core/bin", __FILE__) + "/xcov-core-legacy"

    class Parser

      def self.parse(file, output_directory, ide_foundation_path)
        tmp_dir = File.join(output_directory, 'tmp')
        FileUtils.mkdir_p(tmp_dir) unless File.directory?(tmp_dir)
        report_output = Tempfile.new("report.json", tmp_dir)
        binary_path = ide_foundation_path.nil? ? ENV['XCOV_CORE_LEGACY_BINARY_PATH'] : ENV['XCOV_CORE_BINARY_PATH']
        command = "#{binary_path.shellescape} -s #{file.shellescape} -o #{report_output.path.shellescape}"
        command << " --ide-foundation-path #{ide_foundation_path}" unless ide_foundation_path.nil?
        description = [{ prefix: "Parsing .xccoverage file: " }]
        execute_command(command, description)
        output_file = File.read(report_output.path)
        JSON.parse(output_file)
      end

      def self.execute_command(command, description)
        FastlaneCore::CommandExecutor.execute(
          command: command,
          print_all: true,
          print_command: true,
          prefix: description,
          loading: "Loading...",
          error: proc do |error_output|
            begin
              Xcov::ErrorHandler.handle_error(error_output)
            rescue => ex
              Xcov::SlackPoster.new.run({
                build_errors: 1
              })
              raise ex
            end
          end
        )
      end

    end

  end
end

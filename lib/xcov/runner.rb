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
      # Create output path
      output_path = Xcov.config[:output_directory]
      FileUtils.mkdir_p(output_path)
      resources_path = File.join(output_path, "resources")
      FileUtils.mkdir_p(resources_path)

      # Copy images to output resources folder
      Dir[File.join(File.dirname(__FILE__), "../../assets/images/*")].each do |path|
          FileUtils.cp_r(path, resources_path)
      end

      # Copy stylesheets to output resources folder
      Dir[File.join(File.dirname(__FILE__), "../../assets/stylesheets/*")].each do |path|
          FileUtils.cp_r(path, resources_path)
      end

      # Copy javascripts to output resources folder
      Dir[File.join(File.dirname(__FILE__), "../../assets/javascripts/*")].each do |path|
          FileUtils.cp_r(path, resources_path)
      end

      # Convert report to xCov model objects
      report = Report.map(report_json)

      # Create HTML report
      File.open(File.join(output_path, "index.html"), "wb") do |file|
          file.puts report.html_value
      end

      # Post result
      SlackPoster.new.run(report)

      # Print output
      table_rows = []
      report.targets.each do |target|
        table_rows << [target.name, target.displayable_coverage]
      end
      puts Terminal::Table.new({
        title: "xCov Coverage Report".green,
        rows: table_rows
      })
      puts ""

      # Raise exception in case of failure
      raise "Unable to create coverage report" if report.nil?
    end

  end
end

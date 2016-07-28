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
      report = generate_xcov_report(report_json)
      validate_report(report)
    end

    def parse_xccoverage
      # Find .xccoverage file
      test_logs_path = derived_data_path + "Logs/Test/"
      xccoverage_files = Dir["#{test_logs_path}*.xccoverage"].sort_by { |filename| File.mtime(filename) }.reverse

      unless test_logs_path.directory? && !xccoverage_files.empty?
        ErrorHandler.handle_error("CoverageNotFound")
      end

      Xcov::Core::Parser.parse(xccoverage_files.first)
    end

    def generate_xcov_report report_json
      # Create output path
      output_path = Xcov.config[:output_directory]
      FileUtils.mkdir_p(output_path)

      # Convert report to xCov model objects
      report = Report.map(report_json)

      if Xcov.config[:html_report] then
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

        # Create HTML report
        File.open(File.join(output_path, "index.html"), "wb") do |file|
          file.puts report.html_value
        end
      end

      # Create Markdown report
      if Xcov.config[:markdown_report] then
        File.open(File.join(output_path, "report.md"), "wb") do |file|
          file.puts report.markdown_value
        end
      end

      # Create JSON report
      if Xcov.config[:json_report] then
        File.open(File.join(output_path, "report.json"), "wb") do |file|
          file.puts report.json_value.to_json
        end
      end

      # Post result
      SlackPoster.new.run(report)

      # Print output
      table_rows = []
      report.targets.each do |target|
        table_rows << [target.name, target.displayable_coverage]
      end
      puts Terminal::Table.new({
        title: "xcov Coverage Report".green,
        rows: table_rows
      })
      puts ""

      # Raise exception in case of failure
      raise "Unable to create coverage report" if report.nil?

      report
    end

    def validate_report report
      exit_status = 0

      # Raise exception if overall coverage
      minimumPercentage = Xcov.config[:minimum_coverage_percentage] / 100
      if minimumPercentage > report.coverage
        exit_status = 1

        UI.user_error!("Actual Code Coverage (#{"%.2f%" % (report.coverage*100)}) below threshold of #{"%.2f%" % (minimumPercentage*100)}")
      end

      exit_status
    end

    # Auxiliar methods

    def derived_data_path
      # If DerivedData path was supplied, return
      return Pathname.new(Xcov.config[:derived_data_path]) unless Xcov.config[:derived_data_path].nil?

      # Otherwise check project file
      product_builds_path = Pathname.new(Xcov.project.default_build_settings(key: "SYMROOT"))
      return product_builds_path.parent.parent
    end

  end
end

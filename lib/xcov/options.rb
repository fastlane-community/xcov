require "fastlane_core"
require "credentials_manager"

module Xcov
  class Options

    def self.available_options
      containing = self.containing_folder

      return [
        # Project options
        FastlaneCore::ConfigItem.new(
          key: :workspace,
          short_option: "-w",
          env_name: "XCOV_WORKSPACE",
          optional: true,
          description: "Path the workspace file",
          verify_block: proc do |value|
            v = File.expand_path(value.to_s)
            raise "Workspace file not found at path '#{v}'".red unless File.exist?(v)
            raise "Workspace file invalid".red unless File.directory?(v)
            raise "Workspace file is not a workspace, must end with .xcworkspace".red unless v.include?(".xcworkspace")
          end
        ),
        FastlaneCore::ConfigItem.new(
          key: :project,
          short_option: "-p",
          optional: true,
          env_name: "XCOV_PROJECT",
          description: "Path the project file",
          verify_block: proc do |value|
            v = File.expand_path(value.to_s)
            raise "Project file not found at path '#{v}'".red unless File.exist?(v)
            raise "Project file invalid".red unless File.directory?(v)
            raise "Project file is not a project file, must end with .xcodeproj".red unless v.include?(".xcodeproj")
          end
        ),
        FastlaneCore::ConfigItem.new(
          key: :scheme,
          short_option: "-s",
          optional: true,
          env_name: "XCOV_SCHEME",
          description: "The project's scheme. Make sure it's marked as `Shared`"
        ),
        FastlaneCore::ConfigItem.new(
          key: :configuration,
          short_option: "-q",
          env_name: "XCOV_CONFIGURATION",
          description: "The configuration used when building the app. Defaults to 'Release'",
          optional: true
        ),
        FastlaneCore::ConfigItem.new(
          key: :source_directory,
          short_option: "-r",
          optional: true,
          env_name: "XCOV_SOURCE_DIRECTORY",
          description: "The path to project's root directory",
          verify_block: proc do |value|
            v = File.expand_path(value.to_s)
            raise "Specified source directory does not exist".red unless File.exist?(v)
            raise "Invalid source directory path, it must point to a directory".red unless File.directory?(v)
          end
        ),
        FastlaneCore::ConfigItem.new(
          key: :derived_data_path,
          short_option: "-j",
          env_name: "XCOV_DERIVED_DATA_PATH",
          description: "The directory where build products and other derived data will go",
          optional: true,
          verify_block: proc do |value|
            v = File.expand_path(value.to_s)
            raise "Specified derived data directory does not exist".red unless File.exist?(v)
            raise "Invalid derived data path, it must point to a directory".red unless File.directory?(v)
          end
        ),
        FastlaneCore::ConfigItem.new(
          key: :xccov_file_direct_path,
          short_option: "-f",
          env_name: "XCOV_FILE_DIRECT_PATH",
          description: "The path to the xccoverage/xccovreport/xcresult file to parse to generate code coverage",
          optional: true,
          verify_block: proc do |value|
            v = File.expand_path(value.to_s)
            raise "xccoverage/xccovreport/xcresult file does not exist".red unless File.exist?(v)
            raise "Invalid xccov file type (must be xccoverage, xccovreport, xcresult)".red unless value.end_with? "xccoverage" or value.end_with? "xccovreport" or value.end_with? "xcresult"
          end
        ),
        FastlaneCore::ConfigItem.new(
          key: :output_directory,
          short_option: "-o",
          env_name: "XCOV_OUTPUT_DIRECTORY",
          description: "The directory in which all reports will be stored",
          default_value: File.join(containing, "xcov_report"),
          default_value_dynamic: true
        ),

        # Report options
        FastlaneCore::ConfigItem.new(
          key: :html_report,
          env_name: "XCOV_HTML_REPORT",
          description: "Produce an HTML report",
          optional: true,
          is_string: false,
          default_value: true
        ),
        FastlaneCore::ConfigItem.new(
          key: :markdown_report,
          env_name: "XCOV_MARKDOWN_REPORT",
          description: "Produce a Markdown report",
          optional: true,
          is_string: false,
          default_value: false
        ),
        FastlaneCore::ConfigItem.new(
          key: :json_report,
          env_name: "XCOV_JSON_REPORT",
          description: "Produce a JSON report",
          optional: true,
          is_string: false,
          default_value: false
        ),
        FastlaneCore::ConfigItem.new(
          key: :minimum_coverage_percentage,
          short_option: "-m",
          env_name: "XCOV_MINIMUM_COVERAGE_PERCENTAGE",
          description: "Raise exception if overall coverage percentage is under this value (ie. 75)",
          type: Float,
          default_value: 0
        ),

        # Slack options
        FastlaneCore::ConfigItem.new(
          key: :slack_url,
          short_option: "-i",
          env_name: "SLACK_URL",
          description: "Create an Incoming WebHook for your Slack group to post results there",
          optional: true,
          verify_block: proc do |value|
            raise "Invalid URL, must start with https://" unless value.start_with? "https://"
          end
        ),
        FastlaneCore::ConfigItem.new(
          key: :slack_channel,
          short_option: "-e",
          env_name: "XCOV_SLACK_CHANNEL",
          description: "#channel or @username",
          optional: true
        ),
        FastlaneCore::ConfigItem.new(
          key: :skip_slack,
          description: "Don't publish to slack, even when an URL is given",
          is_string: false,
          default_value: false
        ),
        FastlaneCore::ConfigItem.new(
          key: :slack_username,
          description: "The username which is used to publish to slack",
          default_value: "xcov",
          optional: true
        ),
        FastlaneCore::ConfigItem.new(
          key: :slack_message,
          description: "The message which is published together with a successful report",
          default_value: "Your *xcov* coverage report",
          optional: true
        ),

        # Exclusion options
        FastlaneCore::ConfigItem.new(
          key: :ignore_file_path,
          short_option: "-x",
          env_name: "XCOV_IGNORE_FILE_PATH",
          description: "Relative or absolute path to the file containing the list of ignored files",
          default_value: File.join(containing, ".xcovignore"),
          default_value_dynamic: true
        ),
        FastlaneCore::ConfigItem.new(
          key: :include_test_targets,
          env_name: "XCOV_INCLUDE_TEST_TARGETS",
          description: "Enables coverage reports for .xctest targets",
          is_string: false,
          default_value: false
        ),
        FastlaneCore::ConfigItem.new(
          key: :exclude_targets,
          optional: true,
          conflicting_options: [:include_targets, :only_project_targets],
          description: "Comma separated list of targets to exclude from coverage report"
        ),
        FastlaneCore::ConfigItem.new(
          key: :include_targets,
          optional: true,
          conflicting_options: [:exclude_targets, :only_project_targets],
          description: "Comma separated list of targets to include in coverage report. If specified then exlude_targets will be ignored"
        ),
        FastlaneCore::ConfigItem.new(
          key: :only_project_targets,
          optional: true,
          conflicting_options: [:exclude_targets, :include_targets],
          description: "Display the coverage only for main project targets (e.g. skip Pods targets)",
          is_string: false,
          default_value: false
        ),

        # Coveralls options
        FastlaneCore::ConfigItem.new(
          key: :disable_coveralls,
          env_name: "DISABLE_COVERALLS",
          default_value: false,
          is_string: false,
          optional: true,
          description: "Add this flag to disable automatic submission to Coveralls"
        ),
        FastlaneCore::ConfigItem.new(
          key: :coveralls_service_name,
          env_name: "COVERALLS_SERVICE_NAME",
          optional: true,
          conflicting_options: [:coveralls_repo_token],
          description: "Name of the CI service compatible with Coveralls. i.e. travis-ci. This option must be defined along with coveralls_service_job_id"
        ),
        FastlaneCore::ConfigItem.new(
          key: :coveralls_service_job_id,
          env_name: "COVERALLS_SERVICE_JOB_ID",
          optional: true,
          conflicting_options: [:coveralls_repo_token],
          description: "Name of the current job running on a CI service compatible with Coveralls. This option must be defined along with coveralls_service_name"
        ),
        FastlaneCore::ConfigItem.new(
          key: :coveralls_repo_token,
          env_name: "COVERALLS_REPO_TOKEN",
          optional: true,
          conflicting_options: [:coveralls_service_name, :coveralls_service_job_id],
          description: "Repository token to be used by integrations not compatible with Coveralls"
        ),

        # Fastlane compatibility issue fix
        FastlaneCore::ConfigItem.new(
          key: :xcconfig,
          env_name: "XCOV_XCCONFIG",
          description: "Use an extra XCCONFIG file to build your app",
          optional: true,
          verify_block: proc do |value|
            UI.user_error!("File not found at path '#{File.expand_path(value)}'") unless File.exist?(value)
          end
        ),

        # xccovreport compatibility options
        FastlaneCore::ConfigItem.new(
          key: :ideFoundationPath,
          env_name: "XCOV_IDE_FOUNDATION_PATH",
          description: "Absolute path to the IDEFoundation.framework binary",
          optional: true,
          default_value: File.join(`/usr/bin/xcode-select -p`.delete!("\n"), "../Frameworks/IDEFoundation.framework/Versions/A/IDEFoundation"),
          default_value_dynamic: true
        ),
        FastlaneCore::ConfigItem.new(
          key: :legacy_support,
          env_name: "XCOV_LEGACY_SUPPORT",
          description: "Whether xcov should parse a xccoverage file instead on xccovreport",
          optional: true,
          is_string: false,
          default_value: false
        )
      ]
    end

    def self.containing_folder
      if FastlaneCore::Helper.fastlane_enabled?
        FastlaneCore::FastlaneFolder.path
      else
        '.'
      end
    end

  end
end

require "fastlane_core"
require "credentials_manager"

module Xcov
  class Options

    def self.available_options
      containing = FastlaneCore::Helper.fastlane_enabled? ? './fastlane' : '.'

      [
        FastlaneCore::ConfigItem.new(key: :workspace,
                                     short_option: "-w",
                                     env_name: "XCOV_WORKSPACE",
                                     optional: true,
                                     description: "Path the workspace file",
                                     verify_block: proc do |value|
                                       v = File.expand_path(value.to_s)
                                       raise "Workspace file not found at path '#{v}'".red unless File.exist?(v)
                                       raise "Workspace file invalid".red unless File.directory?(v)
                                       raise "Workspace file is not a workspace, must end with .xcworkspace".red unless v.include?(".xcworkspace")
                                     end),
        FastlaneCore::ConfigItem.new(key: :project,
                                     short_option: "-p",
                                     optional: true,
                                     env_name: "XCOV_PROJECT",
                                     description: "Path the project file",
                                     verify_block: proc do |value|
                                       v = File.expand_path(value.to_s)
                                       raise "Project file not found at path '#{v}'".red unless File.exist?(v)
                                       raise "Project file invalid".red unless File.directory?(v)
                                       raise "Project file is not a project file, must end with .xcodeproj".red unless v.include?(".xcodeproj")
                                     end),
        FastlaneCore::ConfigItem.new(key: :scheme,
                                     short_option: "-s",
                                     optional: true,
                                     env_name: "XCOV_SCHEME",
                                     description: "The project's scheme. Make sure it's marked as `Shared`"),
        FastlaneCore::ConfigItem.new(key: :derived_data_path,
                                     short_option: "-j",
                                     env_name: "XCOV_DERIVED_DATA_PATH",
                                     description: "The directory where build products and other derived data will go",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :output_directory,
                                     short_option: "-o",
                                     env_name: "XCOV_OUTPUT_DIRECTORY",
                                     description: "The directory in which all reports will be stored",
                                     default_value: File.join(containing, "xcov_report")),
        FastlaneCore::ConfigItem.new(key: :html_report,
                                     env_name: "XCOV_HTML_REPORT",
                                     description: "Produce an HTML report",
                                     optional: true,
                                     is_string: false,
                                     default_value: true),
        FastlaneCore::ConfigItem.new(key: :markdown_report,
                                     env_name: "XCOV_MARKDOWN_REPORT",
                                     description: "Produce a Markdown report",
                                     optional: true,
                                     is_string: false,
                                     default_value: false),
        FastlaneCore::ConfigItem.new(key: :json_report,
                                     env_name: "XCOV_JSON_REPORT",
                                     description: "Produce a JSON report",
                                     optional: true,
                                     is_string: false,
                                     default_value: false),
        FastlaneCore::ConfigItem.new(key: :minimum_coverage_percentage,
                                     short_option: "-m",
                                     env_name: "XCOV_MINIMUM_COVERAGE_PERCENTAGE",
                                     description: "Raise exception if overall coverage percentage is under this value (ie. 75)",
                                     type: Float,
                                     default_value: 0),
       FastlaneCore::ConfigItem.new(key: :ignore_file_path,
                                    short_option: "-x",
                                    env_name: "XCOV_IGNORE_FILE_PATH",
                                    description: "Relative or absolute path to the file containing the list of ignored files",
                                    default_value: File.join(containing, ".xcovignore")),
       FastlaneCore::ConfigItem.new(key: :include_test_targets,
                                    env_name: "XCOV_INCLUDE_TEST_TARGETS",
                                    description: "Enables coverage reports for .xctest targets",
                                    is_string: false,
                                    default_value: false),
        FastlaneCore::ConfigItem.new(key: :slack_url,
                                     short_option: "-i",
                                     env_name: "SLACK_URL",
                                     description: "Create an Incoming WebHook for your Slack group to post results there",
                                     optional: true,
                                     verify_block: proc do |value|
                                       raise "Invalid URL, must start with https://" unless value.start_with? "https://"
                                     end),
        FastlaneCore::ConfigItem.new(key: :slack_channel,
                                     short_option: "-e",
                                     env_name: "XCOV_SLACK_CHANNEL",
                                     description: "#channel or @username",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :skip_slack,
                                     description: "Don't publish to slack, even when an URL is given",
                                     is_string: false,
                                     default_value: false),
        FastlaneCore::ConfigItem.new(key: :exclude_targets,
                                     optional: true,
                                     description: "Comma separated list of targets to exclude from coverage report")
      ]
    end

  end
end

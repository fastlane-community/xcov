require "fastlane_core"

module Xcov
  class Manager

    def work(options)
      # Set command options
      Xcov.config = options

      # Set project options
      FastlaneCore::Project.detect_projects(options)
      Xcov.project = FastlaneCore::Project.new(options)

      # Set ignored files handler
      Xcov.ignore_handler = IgnoreHandler.new

      # Print summary
      FastlaneCore::PrintTable.print_values(config: options, hide_keys: [:slack_url], title: "Summary for xcov #{Xcov::VERSION}")

      # Run xcov
      Runner.new.run
    end

  end
end

require "fastlane_core"

module Xcov
  class Manager

    def work(options)
      Xcov.config = options
      FastlaneCore::PrintTable.print_values(config: options, hide_keys: [:slack_url], title: "Summary for xCov #{Xcov::VERSION}")
      Runner.new.run
    end

  end
end

require "commander"
require "fastlane_core"

HighLine.track_eof = false

module Xcov
  class CommandsGenerator

    include Commander::Methods

    FastlaneCore::CommanderGenerator.new.generate(Xcov::Options.available_options)

    def self.start
      FastlaneCore::UpdateChecker.start_looking_for_update("xcov")
      new.run
     ensure
       FastlaneCore::UpdateChecker.show_update_status("xcov", Xcov::VERSION)
    end

    def convert_options(options)
      converted_options = options.__hash__.dup
      converted_options.delete(:verbose)
      converted_options
    end

    def run
      program :version, Xcov::VERSION
      program :description, Xcov::DESCRIPTION
      program :help, "Author", "Carlos Vidal <nakioparkour@gmail.com>"
      program :help, "Website", "http://www.nakiostudio.com"
      program :help, "GitHub", "https://github.com/nakiostudio/xcov"
      program :help_formatter, :compact

      global_option("--verbose") { $verbose = true }

      command :report do |c|
        c.syntax = "Xcov"
        c.description = Xcov::DESCRIPTION
        c.action do |_args, options|
          config = FastlaneCore::Configuration.create(Xcov::Options.available_options, convert_options(options))
          Xcov::Manager.new(config).run()
        end
      end

      default_command :report
      run!
    end

  end
end

require 'json'
require 'xcov/version'
require 'xcov/manager'
require 'xcov/options'
require 'xcov/runner'
require 'xcov/error_handler'
require 'xcov/slack_poster'
require 'xcov/model/base'
require 'xcov/model/report'
require 'xcov/model/target'
require 'xcov/model/source'
require 'xcov/model/function'
require 'fastlane_core'

module Xcov
  class << self
    attr_accessor :config
    attr_accessor :project

    def config=(value)
      @config = value

      FastlaneCore::Project.detect_projects(value)
      @project = FastlaneCore::Project.new(config)
      @project.select_scheme
    end

  end

  Helper = FastlaneCore::Helper
  UI = FastlaneCore::UI
end

require 'json'
require 'xcov/version'
require 'xcov/manager'
require 'xcov/options'
require 'xcov/ignore_handler'
require 'xcov/error_handler'
require 'xcov/coveralls_handler'
require 'xcov/slack_poster'
require 'xcov/model/base'
require 'xcov/model/report'
require 'xcov/model/target'
require 'xcov/model/source'
require 'xcov/model/function'
require 'xcov/model/line'
require 'xcov/model/range'
require 'xcov/project_extensions'
require 'fastlane_core'

module Xcov
  class << self

    attr_accessor :config
    attr_accessor :ignore_handler
    attr_accessor :project

    def project=(value)
      @project = value
      @project.select_scheme
    end

  end

  Helper = FastlaneCore::Helper
  UI = FastlaneCore::UI

end

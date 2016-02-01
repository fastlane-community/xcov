require "xcov-core/version"

module Xcov
  module Core
    ENV['XCOV_CORE_LIBRARY_PATH'] = File.expand_path("../xcov-core/bin", __FILE__) + "/xcov-core"
  end
end

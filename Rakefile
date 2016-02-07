# require "bundler/gem_tasks"
#
# Dir.glob("tasks/**/*.rake").each(&method(:import))
#
# task default: :spec

task :dev do
  sh "gem build xcov.gemspec"
  sh "gem install xcov-0.1.gem"
  sh 'xcov tests -w "/Users/nakio/Projects/LST-LystSDK-iOS/LystSDK/LystSDK.xcworkspace" -s LystSDK -o "/Users/nakio/Desktop/xcov_report"'
end

# task :test do
#   sh "../fastlane/bin/fastlane test"
# end
#
# task :push do
#   sh "../fastlane/bin/fastlane release"
# end

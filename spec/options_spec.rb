require "spec_helper"
require "fastlane_core"
require "xcov/options"

describe Xcov::Options do
  subject(:options) { described_class.available_options }

  def option(key)
    options.find { |item| item.key == key }
  end

  it "marks the Slack webhook URL as sensitive" do
    expect(option(:slack_url).sensitive).to be true
  end

  it "marks the Coveralls repository token as sensitive" do
    expect(option(:coveralls_repo_token).sensitive).to be true
  end
end

require "spec_helper"

describe "xcov command" do
  subject(:xcov) { `#{File.expand_path("../bin/xcov", __dir__)} #{args} 2>/dev/null` }

  describe "xccov_file_direct_path option" do
    context "when a string is passed" do
      let(:args) { "--xccov_file_direct_path foo" }

      it "accepts a string" do
        expect(subject).to include '["foo"]'
      end
    end

    context "when a string is passed" do
      let(:args) { "--xccov_file_direct_path foo,bar" }

      it "accepts a comma-separated string and convert it to an array of strings" do
        expect(subject).to include '["foo", "bar"]'
      end
    end
  end
end

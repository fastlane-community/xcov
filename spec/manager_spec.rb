require "fileutils"
require "fastlane_core"
require "xcov/manager"

describe Xcov::Manager do
  subject(:manager) { described_class.new(config) }

  before do
    project = double()
    allow(project).to receive(:select_scheme)
    allow(FastlaneCore::Project).to receive(:new).and_return project
    allow(FastlaneCore::Project).to receive(:detect_projects)
  end

  describe "#xccov_file_direct_paths" do
    subject { manager.send(:xccov_file_direct_paths) }

    context "when xccov_file_direct_path is nil" do
      let(:config) { {} }

      it { is_expected.to eq [] }
    end

    context "when xccov_file_direct_path is an array of strings" do
      let(:config) { {xccov_file_direct_path: ["foo", "bar"]} }

      it "returns given strings" do
        expect(subject).to eq ["foo", "bar"]
      end
    end
  end
end

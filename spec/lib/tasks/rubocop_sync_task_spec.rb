# frozen_string_literal: true

require "rails_helper"
require "rake"

Rails.application.load_tasks if Rake::Task.tasks.empty?

RSpec.describe("rubocop:sync_rules task", type: :task) do
  subject(:rubocop_sync_task) { Rake::Task["rubocop:sync_rules"] }

  let(:rubocop_sync_instance) { RubocopSync.new }
  let(:mock_official_rules)   { ["Rule1", "Rule2", "MissingRule"] }
  let(:mock_active_rules)     { ["Rule1", "Rule2"] }

  before do
    allow(RubocopSync).to receive(:new).and_return(rubocop_sync_instance)
    allow(rubocop_sync_instance).to receive(:fetch_official_rules).and_return(mock_official_rules)
    allow(rubocop_sync_instance).to receive(:fetch_active_rules).and_return(mock_active_rules)
  end

  it "prints the missing rules" do
    captured_output = capture_stdout { rubocop_sync_task.invoke }

    expect(captured_output).to include("MissingRule is missing from rubocop")
  end
end

RSpec.describe(RubocopSync, type: :task) do
  let(:rubocop_sync_instance) { described_class.new }

  describe "#fetch_official_rules" do
    it "fetches a list of rules from the official rubocop docs" do
      stub_request(:get, /docs\.rubocop\.org/)
        .to_return(body: "<html><div class='sect1'><h2>Rule1</h2><h2>Rule2</h2></div></html>")

      expect(rubocop_sync_instance
        .send(:fetch_official_rules, "https://docs.rubocop.org/rubocop", "Layout"))
        .to eq(["Rule1", "Rule2"])
    end
  end

  describe "#fetch_active_rules" do
    it "fetches the active rules from local yml files" do
      mock_yml = <<~YAML
        Rule1:
          Enabled: true
          EnforcedStyle: test
        Rule2:
          Enabled: false
      YAML

      allow(File).to receive(:read).with("./rubocop/layout_rules.yml").and_return(mock_yml)

      expect(rubocop_sync_instance.send(:fetch_active_rules, "layout")).to eq(["Rule1", "Rule2"])
    end
  end
end

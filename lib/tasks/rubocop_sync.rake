# frozen_string_literal: true

namespace :rubocop do
  desc "find missing or no longer relevant rubocop rules"
  task sync_rules: :environment do
    RubocopSync.new.sync_rules
  end
end

class RubocopSync
  RUBOCOP_METADATA = [
    {
      base_docs_url: "https://docs.rubocop.org/rubocop",
      departments: ["Bundler", "Layout", "Lint", "Metrics", "Naming", "Security", "Style"]
    },
    {
      base_docs_url: "https://docs.rubocop.org/rubocop-performance",
      departments: ["Performance"]
    },
    {
      base_docs_url: "https://docs.rubocop.org/rubocop-rails",
      departments: ["Rails"]
    },
    {
      base_docs_url: "https://docs.rubocop.org/rubocop-rspec",
      departments: ["RSpec/Capybara", "RSpec/FactoryBot", "RSpec/Rails", "RSpec"]
    }
  ].freeze

  def sync_rules
    RUBOCOP_METADATA.each { |rules_set| sync_rules_set(rules_set) }
  end

  private

  def sync_rules_set(rules_set)
    rules_set[:departments].each do |department|
      parameterized_department = department.parameterize.underscore
      official_rules = fetch_official_rules(rules_set[:base_docs_url], parameterized_department)
      active_rules   = fetch_active_rules(parameterized_department)
      print_missing_rules(official_rules, active_rules, parameterized_department)
    end
  end

  # Extract all rules being used in each file within the rubocop directory.
  def fetch_active_rules(parameterized_department)
    department_file = File.read("./rubocop/#{parameterized_department}_rules.yml")

    # The following regex pattern will match only non-indented lines.
    # This will return a list of only the names of each active rule.
    department_file.scan(/(^\S.*(?:\n^\h+.*)*)/).flatten.map! do |match|
      match.delete_suffix!(":")
    end
  end

  # Return all official rules from a specific Rubocop department.
  def fetch_official_rules(base_url, parameterized_department)
    url = "#{base_url}/cops_#{parameterized_department}.html"
    doc = Nokogiri::HTML(URI.parse(url).open)
    sleep(0.2) # Prevent sending several requests at the same time.
    doc.xpath("//div[@class='sect1']/h2/text()").map(&:to_s)
  end

  # Compare the rules being currently used by this app with the list of official rules in
  # order to find any rules that may be missing.
  def print_missing_rules(official_rules, active_rules, parameterized_department)
    missing_rules = official_rules - active_rules
    missing_rules.each do |rule|
      p "#{rule} is missing from rubocop/#{parameterized_department}_rules.yml"
    end
  end
end

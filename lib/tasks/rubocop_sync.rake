# frozen_string_literal: true

namespace :rubocop do
  desc "find missing or no longer relevant rubocop rules"
  task sync_rules: :environment do
    rubocop_metadata = [
      {
        base_docs_url: "https://docs.rubocop.org/rubocop/",
        departments: ["Bundler", "Layout", "Lint", "Metrics", "Naming", "Security", "Style"]
      },
      {
        base_docs_url: "https://docs.rubocop.org/rubocop-performance/",
        departments: ["Performance"]
      },
      {
        base_docs_url: "https://docs.rubocop.org/rubocop-rails/",
        departments: ["Rails"]
      },
      {
        base_docs_url: "https://docs.rubocop.org/rubocop-rspec/",
        departments: ["RSpec/Capybara", "RSpec/FactoryBot", "RSpec/Rails", "RSpec"]
      }
    ]

    # Extract all rules being used in each file within the rubocop directory.
    # Then extract all rules from the official docs to compare to.
    rubocop_metadata.each do |data_set|
      data_set[:departments].each do |department|
        parameterized_department = department.parameterize.underscore

        department_file = File.read("./rubocop/#{parameterized_department}_rules.yml")
        # The following regex pattern will match only non-indented lines.
        active_rules = department_file.scan(/(^\S.*(?:\n^\h+.*)*)/).flatten.map! do |match|
          match.delete_suffix!(":")
        end

        url = "#{data_set[:base_docs_url]}cops_#{parameterized_department}.html"
        doc = Nokogiri::HTML(URI.parse(url).open)
        official_rules = doc.xpath("//div[@class='sect1']/h2/text()").map(&:to_s)
        sleep(0.2) # Prevent sending several requests at the same time.

        # Find official rules that are missing from this app:
        missing_rules = official_rules - active_rules
        missing_rules.each do |rule|
          p "#{rule} is missing from rubocop/#{parameterized_department}_rules.yml"
        end
      end
    end
  end
end

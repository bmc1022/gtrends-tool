namespace :rubocop do

  desc 'find missing or no longer relevant rubocop rules'
  task sync_rules: :environment do
    rubocop_metadata = [
      {
        base_url: "https://docs.rubocop.org/rubocop/",
        departments: ["Bundler", "Layout", "Lint", "Metrics", "Naming", "Security", "Style"]
      },
      {
        base_url: "https://docs.rubocop.org/rubocop-performance/",
        departments: ["Performance"]
      },
      {
        base_url: "https://docs.rubocop.org/rubocop-rspec/",
        departments: ["FactoryBot", "Rails", "RSpec"]
      }
    ]

    # Extract all rules being used in each file within the rubocop directory.
    # Then extract all rules from the official docs to compare to.
    rubocop_metadata.each do |data_set|
      data_set[:departments].each do |department|
        department_file = File.read("./rubocop/#{department.downcase}_rules.yml")
        # The following regex pattern will match only non-indented lines.
        active_rules = department_file.scan(/(^\S.*(?:\n^\h+.*)*)/).flatten.map! { |match| match.delete_suffix!(":") }

        doc = Nokogiri::HTML(URI.open("#{data_set[:base_url]}cops_#{department.downcase}.html"))
        official_rules = doc.xpath("//div[@class='sect1']/h2/text()").map(&:to_s)
        sleep(0.2) # Prevent sending several requests at the same time.

        # Find official rules that are missing from this app:
        missing_rules = official_rules - active_rules
        missing_rules.each { |rule| p "#{rule} is missing from rubocop/#{department.downcase}_rules.yml" }
      end
    end
  end

end

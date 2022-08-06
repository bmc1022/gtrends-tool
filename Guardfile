# More info at https://github.com/guard/guard#readme

directories %w(app config lib spec)

# This group prevents RuboCop from running until specs are passing
group :red_green_refactor, halt_on_fail: true do
  rspec_opts = {
    cmd:            'rspec -f doc --fail-fast',
    failed_mode:    :keep,
    all_after_pass: false,
    all_on_start:   false,
    notification:   false
  }

  guard :rspec, rspec_opts do
    watch('spec/spec_helper.rb')                        { 'spec' }
    watch('config/routes.rb')                           { 'spec/routing' }
    watch('app/controllers/application_controller.rb')  { 'spec/controllers' }
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/libs/#{m[1]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| "spec/requests/#{m[1]}_request_spec.rb" }
    watch(%r{^config/(.+)\.rb$})                        { |m| "spec/config/#{m[1]}_spec.rb" }
  end

  guard :rubocop, all_on_start: false do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
  end
end

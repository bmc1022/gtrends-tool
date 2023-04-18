# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.

env :PATH, ENV.fetch("PATH")

set :output, "./log/cron.log"

every 10.minutes do
  rake "cleanup:expired_gtrends"
end

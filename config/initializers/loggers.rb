# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  logfile = File.open(Rails.root.join("log/debug_logger.log"), "a") # Create log file.
  logfile.sync = true # Automatically flush data to file.
  DEBUG_LOGGER = Logger.new(logfile) # Constant accessible anywhere.
  DEBUG_LOGGER.level = Logger::DEBUG
end

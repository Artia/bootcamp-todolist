# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

Time::DATE_FORMATS[:post] = "posted on %b, %m %Y - %I:%M%p"
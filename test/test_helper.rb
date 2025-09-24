require "minitest/autorun"
require "bigdecimal"

# Load all app files automatically
Dir[File.expand_path("../app/models/*.rb", __dir__)].each { |file| require file }
Dir[File.expand_path("../app/services/*.rb", __dir__)].each { |file| require file }

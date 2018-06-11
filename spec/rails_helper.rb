require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"
require "simplecov"
require "capybara/poltergeist"
require "factories"
require "capybara/rails"
require "capybara/rspec"
require "rack/handler/puma"
require "shoulda/matchers"

ActiveRecord::Migration.maintain_test_schema!

# Requires supporting ruby files with custom matchers and macros, etc. in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
include Helpers
# Sorcery helpers
include Sorcery::TestHelpers::Rails
include Sorcery::TestHelpers::Rails::Controller

# Rspec congiguration
RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    Capybara.register_driver :poltergeist_silent do |app|
      Capybara::Poltergeist::Driver.new app, phantomjs_logger: File.open(File::NULL, "w")
    end
    Capybara.javascript_driver = :poltergeist_silent
  end

  config.after(:suite) do
  end

  config.before(:each) do |example|
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.after(:each) do |example|
    DatabaseCleaner.clean_with(:truncation)
    Capybara.reset_sessions!
    Capybara.use_default_driver
    if example.metadata[:js]
      DatabaseCleaner.strategy = :transaction
    end
  end
end

# Simplecov configuration
SimpleCov.start "rails" do
  use_merging false
end

# Shoulda Matchers configuration
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Capybara configuration
Capybara.server_port = 3002
Capybara.default_max_wait_time = 5
Capybara.register_server :rails_puma_custom do |app, port, host|
  Rack::Handler::Puma.run(app, Port: port, Threads: "0:1", Silent: true)
end
Capybara.configure do |config|                                                                     
  config.server = :rails_puma_custom
end

ENV["RAILS_ENV"] = 'test'

if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec/'
    add_filter 'config/'
    add_group "Models", "app/models"
    add_group "Controllers" do |src|
      src.filename.include?('app/controllers') and
      not src.filename.include?('app/controllers/admin')
    end
    add_group "Admin Controllers", "app/controllers/admin"
  end
end

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara-webkit'
require 'authlogic/test_case'
require 'factory_girl'
require 'shoulda/matchers'
require 'vcr'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Capybara.javascript_driver = :webkit

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost = true
  c.default_cassette_options = {
    :match_requests_on => [:uri, :method, :body],
    :record => :new_episodes
  }
  c.debug_logger = File.open Rails.root.join("log/vcr.log"), 'w'
end

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.include Webrat::Matchers
  config.include EtmAuthHelper
  config.include Authlogic::TestCase
  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers

  Sunspot.session = Sunspot::Rails::StubSessionProxy.new(Sunspot.session)
end

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

Dir["./spec/support/**/*.rb"].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods
  config.include RequestsHelper

  config.before(:each) do
    stub_request(:get, latest_incidents_request_path).
      to_return(body: incidents_results_fixture)

    stub_request(:get, "#{incidents_root}?query=Obstruction&occurred_after").
      to_return(body: incidents_results_fixture)

    stub_request(:get, "#{incidents_root}/1").
      to_return(body: incident_result_fixture)
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
pwd = File.expand_path( File.dirname(__FILE__) )
SimpleCov.root(File.join(pwd,'..','..','..'))
SimpleCov.command_name 'rspec-' + ENV['DBADAPTER'].to_s
SimpleCov.start('rails') do
  adapters.delete(:root_filter)
  add_filter do |src|
    !(src.filename =~ /^#{SimpleCov.root}/)
  end
  add_filter do |src|
    src.filename =~ /test_app/
  end
end
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

require 'database_cleaner'
require 'capybara/poltergeist'
require 'capybara/rspec'
require 'capybara/rails'
require File.expand_path("../../lib/debugging", __FILE__)
#require 'rack_session_access/capybara'
Capybara.server_port = Newsletter.site_url.split(/:/).last
Capybara.app_host = Newsletter.site_url

Capybara.default_driver = :rack_test
Capybara.register_driver :poltergeist do |app|
  options = {
    inspector: 'open',
    debug: false,
    phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'],
    js_errors: false
  }
  Capybara::Poltergeist::Driver.new(app, options)
end
Capybara.javascript_driver = :poltergeist

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/support/*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end

source "https://rubygems.org"

# Declare your gem's dependencies in newsletter.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gem 'dotenv-rails', :require => 'dotenv/rails-now'
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"
gem 'jquery-ui-rails'

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

#gem "devise"
#removed since it's not needed in Gem
gem 'mysql2', '~>0.3'
gem "factory_girl_rails", "~>4.3"
gem "faker"
gem "sqlite3"
gem 'pry-rails'
gem 'spring'
gem 'spring-commands-rspec'
gem 'spring-commands-cucumber'
gem 'quiet_assets'
if ENV['POSTGRES']
  gem 'pg'
end

# Testing Gems
group :test do
  gem 'simplecov', require: false
  gem 'database_cleaner'
  gem 'poltergeist'
  gem "rspec-rails", "~>3.2"
  gem "rspec-activemodel-mocks"
  gem "cucumber-rails", require: false
  gem 'brakeman'
  gem 'bundler-audit'
end

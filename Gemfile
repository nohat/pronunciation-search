source 'http://rubygems.org'

gem 'rails', '>=3.1.1'

gem 'sqlite3'
gem "mysql2", "~> 0.3.7", :git => "git://github.com/brianmario/mysql2.git", :ref => "d3a96b8"

# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

gem 'coffee-script'
gem 'compass', ">= 0.11.3"
gem 'friendly_id'
gem 'haml'
gem 'jquery-rails', '>= 1.0.3'
gem 'json'
gem 'kaminari'
gem 'rails3-jquery-autocomplete'
gem 'ruby-graphviz', :require => 'graphviz'
gem 'sass-rails'
gem 'text'
gem 'uglifier'
gem 'state_machine'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :test, :development do
  gem 'linecache19', :git => "git://github.com/mark-moseley/linecache.git"
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'factory_girl_rails'
  gem "rspec-rails", "~> 2.4"
end

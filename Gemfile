source 'http://rubygems.org'

gem 'rails', '~> 3.1.3'

gem 'cancan'
gem 'dynamic_form'
gem 'facets', :require => false
gem 'haml'
gem 'jquery-rails'
gem 'rubycas-client', '~> 2.2.1'
gem 'rubycas-client-rails'
gem 'simple_form'
gem 'spine-rails'
gem 'validates_existence'
gem 'validates_timeliness'

# gem 'haml-rails' # view scaffolds generate HAML instead
# gem 'coffee-filter' # allows CoffeeScript inside Haml views
# gem 'coffeebeans' # allows CoffeeScript views (an alternative to .js.erb)

# Vendorized and patched for Ruby 1.9
gem 'net-ldap'
gem 'echoe', '~> 4.5.6'
gem 'ucb_ldap', :path => 'vendor/gems/ucb_ldap-1.4.2'

gem 'eco' # used by spine-rails generators
group :assets do
  gem 'coffee-rails', '~> 3.1.0'
  gem 'execjs'
  gem 'haml_coffee_assets'
  gem 'sass-rails', '~> 3.1.0'
  gem 'uglifier'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'sqlite3', :platforms => [:mswin, :mingw]
  gem 'sqlite3-ruby', '1.2.5', :require => 'sqlite3', :platforms => [:ruby] # remove after Fall 2011
end
group :test do
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'cucumber-rails-training-wheels'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'email_spec'
  gem 'launchy'
  gem 'shoulda'
  gem 'spork', '~> 0.9.0.rc9'
end

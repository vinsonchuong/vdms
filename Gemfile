source 'http://rubygems.org'

gem 'rails', '~> 3.1.3'

gem 'cancan'
gem 'coffee-filter'
gem 'dynamic_form'
gem 'facets', :require => false
gem 'haml'
gem 'jquery-rails'
gem 'rubycas-client', '~> 2.2.1'
gem 'rubycas-client-rails'
gem 'simple_form'
gem 'spine-rails'
gem 'thin'
gem 'validates_existence'
gem 'validates_timeliness'

# gem 'haml-rails' # view scaffolds generate HAML instead
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
  gem 'rspec-rails', "~> 2.7.0"
  gem 'sqlite3'
end
group :test do
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'cucumber-rails-training-wheels'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'email_spec'
  gem 'launchy'
  gem 'shoulda', '>= 3.0.0.beta2'
  gem 'spork', '~> 0.9.0.rc9'
end

group :production do
  # Needed for asset pipeline on Heroku, remove after switching to Cedar stack
  gem 'therubyracer-heroku', '>= 0.8.1.pre3'
  gem 'pg'
end

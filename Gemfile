source 'http://rubygems.org'

gem 'rails'

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
gem 'ucb_ldap', :path => 'vendor/gems/ucb_ldap-1.4.2'

gem 'eco' # used by spine-rails generators
group :assets do
  gem 'coffee-rails'
  gem 'execjs'
  gem 'haml_coffee_assets'
  gem 'sass-rails'
  gem 'uglifier'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'sqlite3'
end
group :test do
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'cucumber-rails-training-wheels'
  gem 'factory_girl_rails'
  gem 'email_spec'
  gem 'launchy'
  gem 'shoulda', '>= 3.0.0.beta2'
  gem 'spork'
end

group :production do
  # Needed for asset pipeline on Heroku, remove after switching to Cedar stack
  gem 'therubyracer-heroku', '>= 0.8.1.pre3'
  gem 'pg'
end

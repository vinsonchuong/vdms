source 'http://rubygems.org'

gem 'rails', '~> 2.3.14'

gem 'cancan'
gem 'facets', :require => false
gem 'haml'
gem 'rake', '~> 0.8.7'
gem 'rubycas-client'
gem 'validates_existence'
gem 'validates_timeliness', '~> 2.3'

gem 'net-ldap'
gem 'echoe', '~> 4.5.6'
gem 'ucb_ldap', :path => 'vendor/gems/ucb_ldap-1.4.2'

group :cucumber do
  gem 'cucumber', '~> 0.10', :require => false
  gem 'cucumber-rails', '~> 0.3.2', :require => false
  gem 'database_cleaner', :require => false
  gem 'webrat', :path => 'vendor/gems/webrat-0.7.3', :require => false
  gem 'rspec', '~> 1.3', :require => 'spec'
  gem 'rspec-rails', '~> 1.3', :require => false
  gem 'selenium-client'
  gem 'eventmachine', '~> 1.0.0.beta.3'
  gem 'thin'
end

group :test do
  gem 'rspec-rails', '~> 1.3', :require => 'spec/rails'
  gem 'test-unit', '1.2.3'
end

group :cucumber, :development, :test do
  gem 'sqlite3', :platforms => [:mswin, :mingw]
  gem 'sqlite3-ruby', '1.2.5', :require => 'sqlite3', :platforms => [:ruby]
end

group :cucumber, :test do
  gem 'email_spec', '~> 0.6'
  gem 'factory_girl'
  gem 'launchy'
  gem 'shoulda'
end

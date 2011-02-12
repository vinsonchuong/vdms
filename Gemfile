source 'http://rubygems.org'

gem 'rails', '2.3.11'

gem 'cancan', '1.3.4'
gem 'facets', :require => false
gem 'fastercsv'
gem 'haml'
gem 'rubycas-client'
gem 'ruby-net-ldap', :require => 'net/ldap'
gem 'ucb_ldap'
gem 'validates_existence'
gem 'validates_timeliness', '2.3.2'

gem 'win32console', :platforms => [:mswin, :mingw]

group :cucumber do
  gem 'cucumber', :require => false
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner', :require => false
  gem 'webrat', :require => false
  gem 'rspec', '1.3.1', :require => 'spec'
  gem 'rspec-rails', '1.3.3', :require => false
  gem 'selenium-client'
  gem 'thin'
end

group :test do
  gem 'rspec-rails', '1.3.3', :require => 'spec/rails'
  gem 'rcov'
end

group :cucumber, :development, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

group :cucumber, :test do
  gem 'email_spec', '0.6.5'
  gem 'factory_girl'
  gem 'launchy'
  gem 'shoulda', :require => false
end

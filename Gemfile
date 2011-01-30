source 'http://rubygems.org'

gem 'rails', '2.3.10'

gem 'cancan', '1.3.4'
gem 'facets', :require => false
gem 'fastercsv'
gem 'haml'
gem 'rubycas-client'
gem 'ruby-net-ldap', :require => 'net/ldap'
gem 'ucb_ldap'
gem 'validates_existence'
gem 'validates_timeliness', '2.3.2'

group :cucumber, :development, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'  
end

group :cucumber, :test do
  gem 'email_spec', '0.6.5'
  gem 'factory_girl'
  gem 'shoulda', :require => false
end

group :cucumber do
  gem 'cucumber', '0.8.0', :require => false
  gem 'cucumber-rails', '>=0.3.2', :require => false
  gem 'database_cleaner', '>=0.5.0', :require => false
  gem 'webrat', '>=0.7.0', :require => false
  gem 'rspec', '1.3.1', :require => 'spec'
  gem 'rspec-rails', '1.3.3', :require => false
end

group :test do
  gem 'rspec-rails', '1.3.3', :require => 'spec/rails'
end

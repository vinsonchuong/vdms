# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.10' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.autoload_paths += %W( #{RAILS_ROOT}/extras )
  config.autoload_paths += Dir["#{RAILS_ROOT}/app/models/*"].find_all { |f| File.stat(f).directory? }
  config.autoload_paths += Dir["#{RAILS_ROOT}/app/controllers/*"].find_all { |f| File.stat(f).directory? }

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'cancan'
  config.gem 'facets', :lib => false
  config.gem 'fastercsv'
  config.gem 'haml'
  config.gem 'rubycas-client'
  config.gem 'ruby-net-ldap', :lib => 'net/ldap'
  config.gem 'ucb_ldap'
  config.gem 'validates_existence'
  config.gem 'validates_timeliness', :version => '~> 2.3'

  # Require Ruby Facets libraries as needed
  require 'facets/boolean'
  require 'facets/hash/rekey'
  require 'facets/hash/update_each'
  require 'facets/hash/update_keys'
  require 'facets/range/combine'
  require 'facets/range/overlap'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

# Add view paths
ActionController::Base.view_paths += ["#{RAILS_ROOT}/app/views/people", "#{RAILS_ROOT}/app/views/rankings"]

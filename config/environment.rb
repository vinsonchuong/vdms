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

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'facets'
  config.gem 'rubycas-client'
  config.gem 'ruby-net-ldap', :lib => 'net/ldap'
  
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

=begin
The following code block sets up CAS (CalNet Authentication).
CAS requires the following gems:

   rubycas-client 2.2.1
   ruby-net-ldap  0.0.4

Instructions were followed exactly from:

   http://rubycas-client.rubyforge.org/
   https://wikihub.berkeley.edu/display/istas/10+minutes+to+container+based+CAS+and+Directory+Lookups#10minutestocontainerbasedCASandDirectoryLookups-InRails
 
=end

require 'casclient'
require 'casclient/frameworks/rails/filter'

# enable detailed CAS logging
cas_logger = CASClient::Logger.new(RAILS_ROOT+'/log/cas.log')
cas_logger.level = Logger::DEBUG

# set CAS server URL
CASClient::Frameworks::Rails::Filter.configure(
    :cas_base_url  => "https://auth-test.berkeley.edu/cas",
    #:login_url     => "https://cas.example.foo/login",
    #:logout_url    => "https://cas.example.foo/logout",
    #:validate_url  => "https://cas.example.foo/proxyValidate",
    :username_session_key => :cas_user,
    :extra_attributes_session_key => :cas_extra_attributes,
    :logger => cas_logger,
    :authenticate_on_every_request => true
  )

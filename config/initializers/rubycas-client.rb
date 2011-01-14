require 'casclient/frameworks/rails/filter'

CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url  => 'https://auth.berkeley.edu/cas',
  :logout_url => 'https://auth.berkeley.edu/cas/logout?url=http://localhost:3000',
  :username_session_key => :cas_user,
  :extra_attributes_session_key => :cas_attributes,
  :logger => CASClient::Logger.new("#{RAILS_ROOT}/log/cas.log")
)

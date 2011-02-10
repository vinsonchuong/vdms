class Person < ActiveRecord::Base
  include Importable

  ATTRIBUTES = {
    'LDAP ID' => :ldap_id,
    'CalNet ID' => :calnet_id,
    'First Name' => :first_name,
    'Last Name' => :last_name,
    'Email' => :email
  }
  ATTRIBUTE_TYPES = {
    :ldap_id => :string,
    :calnet_id => :string,
    :first_name => :string,
    :last_name => :string,
    :email => :string
  }

  validates_presence_of :ldap_id, :unless => Proc.new {|person| person.class == Admit}
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
end

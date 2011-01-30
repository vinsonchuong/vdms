class Person < ActiveRecord::Base
  include Importable

  ATTRIBUTES = {
    'CalNet ID' => :calnet_id,
    'First Name' => :first_name,
    'Last Name' => :last_name,
    'Email' => :email
  }
  ATTRIBUTE_TYPES = {
    :calnet_id => :string,
    :first_name => :string,
    :last_name => :string,
    :email => :string
  }

  validates_presence_of :calnet_id, :unless => Proc.new {|person| person.class == Admit}
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
end

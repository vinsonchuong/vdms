class Person < ActiveRecord::Base
  after_initialize :set_defaults

  has_many :event_roles , :class_name => 'Role'
  has_many :events, :through => :event_roles

  validates_presence_of :name
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
  validates_inclusion_of :role, :in => ['user', 'facilitator', 'administrator']

  default_scope order('name')

  private

  def set_defaults
    self.role ||= 'user'
  end
end

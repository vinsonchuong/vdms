class Person < ActiveRecord::Base
  after_initialize :set_defaults

  has_many :event_roles , :class_name => 'Role'
  has_many :events, :through => :event_roles
  has_many :host_roles, :class_name => 'Host'
  has_many :host_events, :through => :host_roles, :source => :event
  has_many :visitor_roles, :class_name => 'Visitor'
  has_many :visitor_events, :through => :visitor_roles, :source => :event

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
  validates_inclusion_of :role, :in => ['user', 'facilitator', 'administrator']

  default_scope order('last_name', 'first_name')

  def name
    self.first_name + ' ' + self.last_name
  end

  private

  def set_defaults
    self.role ||= 'user'
  end
end

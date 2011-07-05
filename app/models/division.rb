class Division < ActiveRecord::Base

  belongs_to :settings

  validates_presence_of :name
  validates_existence_of :settings

  def long_name
    STATIC_SETTINGS['divisions'][self.name.downcase]
  end
end

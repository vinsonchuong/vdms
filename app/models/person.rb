class Person < ActiveRecord::Base
  ATTRIBUTES = {
    'CalNet ID' => :calnet_id,
    'First Name' => :first_name,
    'Last Name' => :last_name,
    'Email' => :email
  }

  ## abstract factory
  def self.make_person(klass, args={})
    klass.constantize.send(:new, args)
  end
end

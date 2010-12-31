class Person < ActiveRecord::Base
=begin
  Attributes
    calnet_id
    first_name
    last_name
    email
=end

## abstract factory
def self.make_person(klass, args={})
  klass.constantize.send(:new, args)
end


end

class PeerAdvisor < Person
  ATTRIBUTES = Person::ATTRIBUTES.merge({})

  has_many :admits
end

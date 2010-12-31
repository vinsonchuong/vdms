class Staff < Person

  has_many :admits
  has_many :faculties
  has_many :peer_advisors
  
end

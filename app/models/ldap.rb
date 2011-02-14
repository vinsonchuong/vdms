module LDAP
  def self.find_person(uid)
    entry = UCB::LDAP::Person.find_by_uid(uid)
    return nil if entry.nil?

    self.get_attributes(entry).merge({:role => self.get_role(entry)})
  end

  def self.get_attributes(entry)
    {
      :uid => entry.uid.to_s,
      :calnet_id => entry.berkeleyedustuid.to_s,
      :first_name => entry.first_name.to_s.humanize.gsub(/\b('?[a-z])/) { $1.capitalize },
      :last_name => entry.last_name.to_s.humanize.gsub(/\b('?[a-z])/) { $1.capitalize },
      :email => entry.email.to_s,
      :phone => entry.phone.to_s,
      :department => (org = entry.org_node).nil? ? '' : org.description.first.to_s
    }
  end

  def self.get_role(entry)
    return :undergrad if entry.berkeleyedustuugcode == 'U'
    return :grad if entry.berkeleyedustuugcode == 'G'
    return :faculty if entry.employee_academic?
    return :staff if entry.employee_staff?
    return nil
  end
end


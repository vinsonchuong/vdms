Given /^I am registered as (?:a|an) "([^"]*?)"$/ do |role|
  @current_user = Factory.create(
      :person,
      :ldap_id => 'current_user',
      :name => 'My Name',
      :role => role.downcase
  )
end

Given /^the following people have been added:$/ do |people|
  people.hashes.map {|attrs| Factory.create(:person, attrs)}
end

Given /^I want to manage the person named "([^"]*?)"$/ do |name|
  @person = Person.find_by_name(name)
end

When /^(?:|I )follow "([^"]*)" for the person named "([^"]*)"$/ do |link, name|
  When %Q|I follow "#{link}" within "//*[.='#{name}']/.."|
end

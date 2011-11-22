Given /^I am registered as (?:a|an) "([^"]*?)"$/ do |role|
  @current_user = Factory.create(
      :person,
      :ldap_id => 'current_user',
      :name => 'My Name',
      :role => role.downcase
  )
end

Given /^the following (?:person has|people have) been added:$/ do |people|
  people = people.hashes.map {|attrs| Factory.create(:person, attrs)}
  @person = people.first if people.count == 1
end

Given /^I want to manage the person named "([^"]*?)"$/ do |name|
  @person = Person.find_by_name(name)
end

When /^(?:|I )follow "([^"]*)" for the person named "([^"]*)"$/ do |link, name|
  step %Q|I follow "#{link}" within "//*[.='#{name}']/.."|
end

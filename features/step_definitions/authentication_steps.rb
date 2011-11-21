Given /^I am not signed in$/ do
  RubyCAS::Filter.fake(nil)
  visit RubyCAS::Filter.config[:logout_url]
end


Given /^I am signed in$/ do
  RubyCAS::Filter.fake(@current_user.ldap_id)
end

Given /^I am signed in as (?:a|an) "([^"]*)"$/ do |role|
  Given %Q/I am registered as a "#{role}"/
  Given 'I am signed in'
end

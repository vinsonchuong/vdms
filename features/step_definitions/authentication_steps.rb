Given /^I am not signed in$/ do
  CASClient::Frameworks::Rails::Filter.fake(nil)
  visit CASClient::Frameworks::Rails::Filter.config[:logout_url]
end


Given /^I am signed in$/ do
  CASClient::Frameworks::Rails::Filter.fake(@current_user.ldap_id)
end

Given /^I am signed in as (?:a|an) "([^"]*)"$/ do |role|
  Given %Q/I am registered as a "#{role}"/
  Given 'I am signed in'
end

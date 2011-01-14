Given /^(?:I am|.*? is) not signed in$/ do
  visit CASClient::Frameworks::Rails::Filter.config[:logout_url]
end

Given /^(?:I am|"([^"]*?)" "([^"]*?)" is) registered as a "([^"]*?)"$/ do |first_name, last_name, role|
  @user = Factory.create(role.downcase.gsub(' ', '_').to_sym,
    :calnet_id => '',
    :first_name => first_name || 'My',
    :last_name => last_name || 'Name'
  )
end

When /^I fill in (my|invalid) CalNet account information$/ do |type|
  case type
  when 'my'
    calnet_id = ''
    password = ''
  when 'invalid'
    calnet_id = 'invalid'
    password = 'invalid'
  end

  fill_in 'CalNet ID:', :with => calnet_id
  fill_in 'Passphrase:', :with => password
end

Then /^I should be (?:unable to access ([^"]*?)|asked to sign in)$/ do |page_name|
  unless page_name.nil?
    visit path_to(page_name)
  end
  URI.parse(current_url).host.should == URI.parse(CASClient::Frameworks::Rails::Filter.config[:cas_base_url]).host
end

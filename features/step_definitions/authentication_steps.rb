Given /^(?:I am|.*? is) not signed in$/ do
  visit CASClient::Frameworks::Rails::Filter.config[:logout_url]
end

Given /^(?:I am|"([^"]*?)" "([^"]*?)" is) registered as a "([^"]*?)"(?: in "([^"]*?)"|)$/ do |first_name, last_name, role, division|
  @user = Factory.create(
    :person,
    :name => (first_name || 'My') + (last_name || 'Name'),
    :division => division
  )
  instance_variable_set("@#{role.downcase.gsub(' ', '_')}", @user)
  @event = @event || Factory.create(:event, :name => 'Event')
  case role
    when 'Staff' then @user.update_attribute(:role, 'administrator')
    when 'Peer Advisor' then @user.update_attribute(:role, 'facilitator')
    when 'Faculty' then @event.hosts.create(:person => @user)
    when 'Admit' then @event.visitors.create(:person => @user)
  end
end

Given /^I am a "([^"]*?)"$/ do |role|
  role = case role
         when 'Faculty' then :faculty
         when 'Grad Student' then :grad
         else nil
         end

  LDAP.stub(:find_person).and_return({
    :uid => '12345',
    :first_name => 'My',
    :last_name => 'Name',
    :email => 'myemail@email.com',
    :role => role
  })
end

Given /^(?:I am|.*? is) signed in$/ do
  CASClient::Frameworks::Rails::Filter.fake(@user.nil? ? '12345' : @user.ldap_id)
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
  puts current_url
  URI.parse(current_url).host.should == URI.parse(CASClient::Frameworks::Rails::Filter.config[:login_url]).host
end

When /^I sign out$/ do
  CASClient::Frameworks::Rails::Filter.fake(nil)
  visit '/sign_out'
  visit home_path
  puts current_url
end
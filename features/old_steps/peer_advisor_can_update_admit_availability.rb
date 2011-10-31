When /^I follow "([^"]*)" for the (\w*?) admit$/ do |link, order|
  orders = {'first' => 1, 'second' => 2, 'third' => 3, 'fourth' => 4, 'fifth' => 5}
  When %{I follow "#{link}" within "tbody > tr:nth-of-type(#{orders[order]})"}
end

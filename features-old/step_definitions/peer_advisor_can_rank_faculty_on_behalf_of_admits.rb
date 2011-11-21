When /^I rank the "([^"]*)" host "([^"]*)"$/ do |order, rank|
  orders = {'first' => 0, 'second' => 1, 'third' => 2}
  select rank, :from => "visitor_rankings_attributes_#{orders[order]}_rank"
end

When /^I flag the "([^"]*)" host for removal$/ do |order|
  orders = {'first' => 0, 'second' => 1, 'third' => 2, 'fourth' => 3, 'fifth' => 4}
  check("visitor_rankings_attributes_#{orders[order]}__destroy")
end

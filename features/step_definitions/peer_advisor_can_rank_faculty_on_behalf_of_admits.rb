Given /^my admit has the following faculty rankings:$/ do |faculty_rankings|
  faculty_rankings.hashes.each do |faculty_ranking|
    @admit.faculty_rankings.create(
      :rank => faculty_ranking['rank'].to_i,
      :faculty => Faculty.all.find {|p| "#{p.first_name} #{p.last_name}" == faculty_ranking['faculty']}
    )
  end
end

When /^I fill in "([^"]*)" with "([^"]*)" for the ([^"]*) ranking$/ do |field, value, order|
  orders = {'first' => 0, 'second' => 1, 'third' => 2, 'fourth' => 3, 'fifth' => 4, 'new' => @admit.faculty_rankings.count}
  index = orders[order]
  fill_in("admit_faculty_rankings_attributes_#{index}_#{field.downcase.gsub(' ', '_')}", :with => value)
end

When /^I select "([^"]*)" from "Faculty" for the ([^"]*) ranking$/ do |value, order| 
  orders = {'first' => 0, 'second' => 1, 'third' => 2, 'fourth' => 3, 'fifth' => 4, 'new' => @admit.faculty_rankings.count}
  index = orders[order]
  select(value, :from => "admit_faculty_rankings_attributes_#{index}_faculty_id")
end

When /^I check "Remove" for the ([^"]*) ranking$/ do |order| 
  orders = {'first' => 0, 'second' => 1, 'third' => 2, 'fourth' => 3, 'fifth' => 4, 'new' => @admit.faculty_rankings.count}
  index = orders[order]
  check("admit_faculty_rankings_attributes_#{index}__destroy")
end

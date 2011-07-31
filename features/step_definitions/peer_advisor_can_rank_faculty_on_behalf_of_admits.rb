Given /^my admit has the following faculty rankings:$/ do |faculty_rankings|
  faculty_rankings.hashes.each do |faculty_ranking|
    @admit.visitor.rankings.create(
      :rank => faculty_ranking['rank'].to_i,
      :rankable => Faculty.all.find {|p| "#{p.first_name} #{p.last_name}" == faculty_ranking['faculty']}.host
    )
  end
end

When /^I rank the "([^"]*)" faculty "([^"]*)"$/ do |order, rank|
  orders = {'first' => 0, 'second' => 1, 'third' => 2}
  select rank, :from => "visitor_rankings_attributes_#{orders[order]}_rank"
end

When /^I flag the "([^"]*)" faculty for removal$/ do |order|
  orders = {'first' => 0, 'second' => 1, 'third' => 2, 'fourth' => 3, 'fifth' => 4}
  check("visitor_rankings_attributes_#{orders[order]}__destroy")
end

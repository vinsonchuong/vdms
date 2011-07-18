Given /^(?:I have|my faculty has|"([^"]*)" has) the following admit rankings:$/ do |name, admit_rankings|
  faculty = name.blank? ? @faculty : Faculty.all.detect {|f| f.full_name == name}
  admit_rankings.hashes.each do |admit_ranking|
    faculty.rankings.create(
      :rank => admit_ranking['rank'].to_i,
      :rankable => Admit.all.find {|p| "#{p.first_name} #{p.last_name}" == admit_ranking['admit']},
      :mandatory => admit_ranking['mandatory'].to_b,
      :one_on_one => admit_ranking['one_on_one'].to_b
    )
  end
end

When /^I unselect every area$/ do
  settings = Settings.instance
  settings.areas.keys.each do |area|
    uncheck "filter_#{area}"
  end
end

When /^I rank the "([^"]*)" admit "([^"]*)"$/ do |order, rank|
  orders = {'first' => 0, 'second' => 1, 'third' => 2}
  select rank, :from => "faculty_rankings_attributes_#{orders[order]}_rank"
end

When /^I flag the "([^"]*)" admit as "([^"]*)"$/ do |order, flag|
  orders = {'first' => 0, 'second' => 1, 'third' => 2}
  flags = {'Mandatory' => 'mandatory', '1-On-1' => 'one_on_one'}
  check "faculty_rankings_attributes_#{orders[order]}_#{flags[flag]}"
end

When /^I select "([^"]*)" time slots for the "([^"]*)" admit$/ do |slots, order|
  orders = {'first' => 0, 'second' => 1, 'third' => 2}
  select slots, :from => "faculty_rankings_attributes_#{orders[order]}_num_time_slots"
end

When /^I flag the "([^"]*)" admit for removal$/ do |order|
  orders = {'first' => 0, 'second' => 1, 'third' => 2, 'fourth' => 3, 'fifth' => 4}
  check("faculty_rankings_attributes_#{orders[order]}__destroy")
end

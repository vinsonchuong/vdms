Given /^the following "([^"]*)" have been added:$/ do |role, people|
  result = people.hashes.map {|p| Factory.create(role.singularize.downcase.gsub(' ', '_').to_sym, p)}
  instance_variable_set("@#{role.singularize.downcase.gsub(' ', '_')}", result.first)
end

Given /the "(.*)" for (.*) "(.*) (.*)" is (.*)/ do |attrib, role, first, last, value|
  klass = role.capitalize.constantize
  person = klass.send(:find_by_first_name_and_last_name,first,last)
  person.update_attribute(attrib.downcase.gsub(/ /,'_'), value)
end

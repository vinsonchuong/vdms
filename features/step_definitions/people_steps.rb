Given /^the following "([^"]*)" have been added:$/ do |role, people|
  result = people.hashes.map {|p| Factory.create(role.singularize.downcase.gsub(' ', '_').to_sym, p)}
  instance_variable_set("@#{role.singularize.downcase.gsub(' ', '_')}", result.first)
end

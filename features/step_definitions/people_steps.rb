Given /^the following "([^"]*)" have been added:$/ do |role, people|
  people.hashes.each {|p| Factory.create(role.singularize.downcase.gsub(' ', '_').to_sym, p)}
end

Given /^the following (host|visitor) field types? (?:has|have) been added to the event:$/ do |role, field_types|
  main_attr_names = ['name', 'description', 'data_type']
  field_types = field_types.hashes.map do |attrs|
    main_attrs = {}
    main_attr_names.each {|a| main_attrs[a] = attrs[a]}
    main_attrs['options'] = attrs.reject! {|n, v| main_attr_names.include? n}
    @event.send("#{role}_field_types").create(main_attrs)
  end
  instance_variable_set("@#{role}_field_type", field_types.first) if field_types.count == 1
end

Given /^I want to manage the (host|visitor) field type named "([^"]*)"$/ do |role, name|
  instance_variable_set(
      "@#{role}_field_type",
      @event.send("#{role}_field_types").find_by_name(name)
  )
end

When /^(?:|I )follow "([^"]*)" for the (?:host|visitor) field type named "([^"]*)"$/ do |link, name|
  step %Q|I follow "#{link}" within "//*[.='#{name}']/.."|
end

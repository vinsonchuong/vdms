Given /^the unsatisfied admit threshold is "([^"]*?)"$/ do |threshold|
  settings = Settings.instance
  settings.unsatisfied_admit_threshold = threshold.to_i
  settings.save
end
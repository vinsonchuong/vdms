Webrat.configure do |config|
  config.application_framework = :rails
  config.mode = :selenium
  config.selenium_browser_startup_timeout = 30
  # Selenium defaults to using the selenium environment. Use the following to override this.
  # config.application_environment = :test
end

# this is necessary to have webrat "wait_for" the response body to be available
# when writing steps that match against the response body returned by selenium
World(Webrat::Selenium::Matchers)

Cucumber::Rails::World.use_transactional_fixtures = false

After do
  DatabaseCleaner.clean
end

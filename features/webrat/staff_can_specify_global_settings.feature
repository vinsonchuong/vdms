Feature: Staff can specify global settings

  So that the app has enough information to produce useful results
  As a staff
  I want to specify app-wide settings

  Background: I am signed in as a staff
    Given I am registered as a "Staff"
    And I am signed in

  Scenario: I can specify global settings
    Given I am on the staff dashboard page
    When I follow "Update Global Settings"
    Then I should be on the update global settings page

  Scenario: I specify the time ranges over which meetings will be held

  Scenario: I specify the threshold number of meetings for an admit to be unsatisfied
    Given I am on the update global settings page
    When I fill in "Unsatisfied Admit Threshold" with "5"
    And I press "Save changes"
    Then I should see "Settings were successfully updated."
    And the "Unsatisfied Admit Threshold" field should contain "5"

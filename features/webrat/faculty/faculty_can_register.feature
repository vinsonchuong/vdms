Feature: Faculty can register

  So that I can indicate my meeting preferences
  As a faculty
  I want to register with the app

  Background: I am signed in
    Given I am a "Faculty"
    And I am signed in

  Scenario: I am forced to verify my info
    Given I am on the home page
    When I follow "For Staff"
    Then I should be on the new faculty page

  Scenario: I verify my info
    Given I am on the home page
    When I follow "For Staff"
    And I fill in "Division" with "Computer Science"
    And I fill in "Area" with "Theory"
    And I press "Save changes"
    Then I should see "Faculty was successfully added."

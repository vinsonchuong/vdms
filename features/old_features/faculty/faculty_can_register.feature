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
    When I follow "For Faculty"
    And I select "Computer Science" from "Division"
    And I select "Theory" from "Area"
    And I fill in "Division" with "Computer Science"
    And I fill in "Area" with "Theory"
    And I press "Register"
    Then I should see "Faculty was successfully added."
    And I should be on the faculty dashboard page

  Scenario: I enter invalid info
    Given I am on the home page
    When I follow "For Faculty"
    And I fill in "First Name" with ""
    And I fill in "Email" with "foobar"
    And I press "Register"
    And I should see "First Name can't be blank"
    And I should see "Email is invalid"

  Scenario: I enter invalid info twice
    Given I am on the home page
    When I follow "For Faculty"
    And I fill in "First Name" with ""
    And I fill in "Email" with "foobar"
    And I press "Register"
    And I press "Register"
    And I should see "First Name can't be blank"
    And I should see "Email is invalid"

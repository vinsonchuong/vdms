Feature: Users can update their profiles

  So that the app can make accurate meeting assignments
  As a user
  I want to update my profile

  Background: I am signed in as a user
    Given I am registered as a "User"
    And I am signed in

  Scenario: I can edit my profile
    Given I am on the home page
    When I follow "Edit My Info"
    Then the "Name" field should contain "My Name"

  Scenario: I update my profile
    Given I am on the home page
    When I follow "Edit My Info"
    And I fill in "Email" with "new_email@email.com"
    And I select "Electrical Engineering" from "Division"
    And I select "Artificial Intelligence" from "Area 1"
    And I press "Update My Info"
    Then I should see "Your info was successfully updated."

  Scenario: I try to update my profile with invalid information
    Given I am on the home page
    When I follow "Edit My Info"
    And I fill in "Name" with ""
    And I fill in "Email" with ""
    And I press "Update My Info"
    Then I should see "Name can't be blank"
    And I should see "Email is invalid"

  Scenario: I try to update my profile with invalid information twice
    Given I am on the home page
    When I follow "Edit My Info"
    And I fill in "Name" with ""
    And I fill in "Email" with ""
    And I press "Update My Info"
    And I press "Update My Info"
    Then I should see "Name can't be blank"
    And I should see "Email is invalid"

Feature: Administrators can manage people

  So that the app has accurate info about its users
  As an administrator
  I want to manage people

  Background: I am signed in as an administrator
    Given the following people have been added:
      | ldap_id | role          | name           | email            |
      | ID1     | administrator | Administrator1 | email1@email.com |
      | ID2     | facilitator   | Facilitator1   | email2@email.com |
      | ID3     | user          | User1          | email3@email.com |
      | ID4     | user          | User2          | email4@email.com |
      | ID5     | user          | User3          | email5@email.com |
      | ID6     | user          | User4          | email6@email.com |
    And I am registered as an "Administrator"
    And I am signed in

  Scenario: I view a list of all people
    Given I am on the home page
    When I follow "Manage People"
    Then I should see "Administrator1"
    And I should see "Facilitator1"
    And I should see "User1"
    And I should see "User2"
    And I should see "User3"
    And I should see "User4"

  Scenario Outline: I add a person
    Given I am on the view people page
    When I follow "Add Person"
    And I fill in "CalNet UID" with "<ldap_id>"
    And I select "<role>" from "Role"
    And I fill in "Name" with "<name>"
    And I fill in "Email" with "<email>"
    And I press "Add Person"
    And I should see "<result>" 

    Scenarios: with valid information
      | ldap_id | role | name       | email           | result                         |
      | ID1     | User | First Last | email@email.com | Person was successfully added. |
      | ID2     | User | First Last | email@email.com | Person was successfully added. |

    Scenarios: with invalid information
      | ldap_id | role | name       | email           | result                             |
      | ID1     | User |            | email@email.com | Name can't be blank                |
      | ID1     | User | First Last | invalid_email   | Email is invalid                   |

  Scenario: I add people by importing a CSV with valid data

  Scenario: I try to add people by importing a CSV with some invalid data

  Scenario: I see the person's name while updating his information
    Given I am on the view people page
    When I follow "Edit Info" for the person named "User1"
    Then I should see "User1"

  Scenario: I update a person's information
    Given I am on the view people page
    When I follow "Edit Info" for the person named "User1"
    And I fill in "Email" with "new_email@email.com"
    And I press "Update Person"
    Then I should see "Person was successfully updated."

  Scenario: I try to update a person with invalid information
    Given I am on the view people page
    When I follow "Edit Info" for the person named "User1"
    And I fill in "Name" with ""
    And I press "Update Person"
    Then I should see "Name can't be blank"

  Scenario: I try to update a person with invalid information twice
    Given I am on the view people page
    When I follow "Edit Info" for the person named "User1"
    And I fill in "Name" with ""
    And I press "Update Person"
    And I press "Update Person"
    Then I should see "Name can't be blank"

  Scenario: I see the faculty's name while removing him
    Given I am on the view people page
    When I follow "Remove" for the person named "User1"
    Then I should see "User1"

  Scenario: I remove a faculty
    Given I am on the view people page
    When I follow "Remove Person" for the person named "User1"
    And I press "Remove Person"
    Then I should see "Person was successfully removed."

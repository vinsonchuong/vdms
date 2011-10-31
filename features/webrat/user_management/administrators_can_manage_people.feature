Feature: Administrators can manage people

  So that the app has accurate info about its users
  As an administrator
  I want to manage people

  Background: I am signed in as an administrator
    Given the following people have been added:
      | ldap_id | role          | name           | email            | area_1 | area_2 | area_3 | division |
      | ID1     | administrator | Administrator1 | email1@email.com |        |        |        |          |
      | ID2     | facilitator   | Facilitator1   | email2@email.com |        |        |        |          |
      | ID3     | user          | User1          | email3@email.com | thy    | ai     |        | cs       |
      | ID4     | user          | User2          | email4@email.com | hci    | gr     | ps     | cs       |
      | ID5     | user          | User3          | email5@email.com | sp     |        |        | ee       |
      | ID6     | user          | User4          | email6@email.com | sec    | dbms   |        |          |
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
    And I select "<division>" from "Division"
    And I select "<area>" from "Area"
    And I press "Add Person"
    And I should see "<result>" 

    Scenarios: with valid information
      | ldap_id | role | name       | email           | division               | area                        | result                         |
      | ID1     | User | First Last | email@email.com | Computer Science       | Artificial Intelligence     | Person was successfully added. |
      | ID2     | User | First Last | email@email.com | Electrical Engineering | Communications & Networking | Person was successfully added. |

    Scenarios: with invalid information
      | ldap_id | role | name       | email           | division               | area                    | result                             |
      | ID1     | User |            | email@email.com | Computer Science       | Artificial Intelligence | Name can't be blank                |
      | ID1     | User | First Last | invalid_email   | Computer Science       | Artificial Intelligence | Email is invalid                   |

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

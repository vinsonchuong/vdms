Feature: Staff can manage people

  So that I can add people to the system
  As a staff
  I want to add faculty to the app

  Background: I am signed in as a staff
    Given the following "People" have been added:
      | ldap_id | role          | name           | email            | area_1 | area_2 | area_3 | division |
      | ID1     | administrator | Administrator1 | email1@email.com |        |        |        |          |
      | ID2     | facilitator   | Facilitator1   | email2@email.com |        |        |        |          |
      | ID3     | user          | User1          | email3@email.com | thy    | ai     |        | cs       |
      | ID4     | user          | User2          | email4@email.com | hci    | gr     | ps     | cs       |
      | ID5     | user          | User3          | email5@email.com | sp     |        |        | ee       |
      | ID6     | user          | User4          | email6@email.com | sec    | dbms   |        |          |
    And I am registered as a "Staff"
    And I am signed in

  Scenario: I view a list of all people
    Given I am on the home page
    When I follow "Manage People"
    And I should see "Administrator1"
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
    Given I am on the view people page
    When I follow "Import People"
    And I attach the file "features/assets/valid_faculty.csv" to "CSV File"
    And I press "Import"
    Then I should see "People were successfully imported."
    And I should see "First1"
    And I should see "First2"
    And I should see "First3"

  Scenario: I try to add people by importing a CSV with some invalid data
    Given I am on the view people page
    When I follow "Import People"
    And I attach the file "features/assets/invalid_faculty.csv" to "CSV File"
    And I press "Import"
    Then I should see "Email can't be blank"
    And I should see "Area 1 is not included in the list"
    And I should see "Division is not included in the list"

  Scenario: I see the person's name while updating his information
    Given I am on the view people page
    When I follow "Update Info"
    Then I should see "Administrator1"

  Scenario: I update a person's information
    Given I am on the view people page
    When I follow "Update Info"
    And I fill in "Email" with "new_email@email.com"
    And I press "Update Person"
    Then I should see "Person was successfully updated."

  Scenario: I try to update a person with invalid information
    Given I am on the view people page
    When I follow "Update Info"
    And I fill in "Name" with ""
    And I press "Update Person"
    Then I should see "Name can't be blank"

  Scenario: I try to update a person with invalid information twice
    Given I am on the view people page
    When I follow "Update Info"
    And I fill in "Name" with ""
    And I press "Update Person"
    And I press "Update Person"
    Then I should see "Name can't be blank"

  Scenario: I see the faculty's name while removing him
    Given I am on the view faculty page
    When I follow "Remove"
    Then I should see "Administrator1"

  Scenario: I remove a faculty
    Given I am on the view faculty page
    When I follow "Remove Person"
    And I press "Remove Person"
    Then I should see "Person was successfully removed."

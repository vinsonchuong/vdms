Feature: Staff can manage visitors

  To ensure that the visitors' information and preferences are correct
  As a staff
  I want to manage visitors

  Background: I am signed in as a staff
    Given the following "People" have been added:
      | ldap_id | role          | name           | email            | area_1 | area_2 | area_3 | division |
      | ID1     | administrator | Administrator1 | email1@email.com |        |        |        |          |
      | ID2     | facilitator   | Facilitator1   | email2@email.com |        |        |        |          |
      | ID3     | user          | User1          | email3@email.com | thy    | ai     |        | cs       |
      | ID4     | user          | User2          | email4@email.com | hci    | gr     | ps     | cs       |
      | ID5     | user          | User3          | email5@email.com | sp     |        |        | ee       |
      | ID6     | user          | User4          | email6@email.com | sec    | dbms   |        |          |
    And the following events have been added:
      | name      | meeting_length | meeting_gap | max_meetings_per_visitor |
      | Visit Day | 900            | 300         | 10                       |
      | Tapia     | 900            | 300         | 10                       |
    And the event has the following meeting times:
      | begin            | end              |
      | 1/1/2011 09:00AM | 1/1/2011 09:15AM |
      | 1/1/2011 09:15AM | 1/1/2011 09:30AM |
      | 1/1/2011 09:30AM | 1/1/2011 09:45AM |
      | 1/1/2011 09:45AM | 1/1/2011 10:00AM |
      | 1/1/2011 10:00AM | 1/1/2011 10:15AM |
      | 1/1/2011 10:15AM | 1/1/2011 10:30AM |
      | 1/1/2011 10:30AM | 1/1/2011 10:45AM |
      | 1/1/2011 10:45AM | 1/1/2011 11:00AM |
      | 1/1/2011 02:00PM | 1/1/2011 02:15PM |
      | 1/1/2011 02:15PM | 1/1/2011 02:30PM |
      | 1/1/2011 02:30PM | 1/1/2011 02:45PM |
    And the following "Visitors" have been added to the event:
      | name  |
      | User1 |
      | User2 |
    And I am registered as a "Staff"
    And I am signed in

  Scenario: I view a list of visitors
    Given I am on the view event page
    When I follow "Manage Visitors"
    Then I should be on the view visitors page
    And I should see "User1"
    And I should see "User2"

  Scenario Outline: I add a visitor
    Given I am on the view visitors page
    When I follow "Add Visitor"
    And I select "<name>" from "Person"
    And I press "Add Visitor"
    And I should see "<result>" 

    Scenarios: with valid information
      | name  | result                          |
      | User3 | Visitor was successfully added. |
      | User4 | Visitor was successfully added. |

  Scenario: I add visitors by importing a CSV with valid data

  Scenario: I see the visitor's name while updating his information
    Given I am on the view visitors page
    When I follow "Edit Info"
    Then I should see "User1"

  Scenario: I see the visitor's name while updating his availability
    Given I am on the view visitors page
    When I follow "Update Availability"
    Then I should see "User1"

  Scenario: I update an visitor's availability
    Given I am on the view visitors page
    When I follow "Update Availability"
    And I flag the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" slot as available
    And I flag the "1/1/2011 10:00AM" to "1/1/2011 10:15AM" slot as available
    And I press "Update Availability"
    Then I should see "Visitor was successfully updated"
    And I should be on the edit visitor availability page

  Scenario: I see the visitor's name while updating his host rankings
    Given the following "Hosts" have been added:
      | name    | email            |
      | Aaa Aaa | email1@email.com |
      | Bbb Bbb | email2@email.com |
      | Ccc Ccc | email3@email.com |
    And I am on the view visitors page
    When I follow "Update Rankings"
    And I check "Aaa Aaa"
    And I press "Rank Hosts"
    Then I should see "User1"

  Scenario: I update an admit's faculty rankings
    Given the following "Hosts" have been added:
      | name    | email            |
      | Aaa Aaa | email1@email.com |
      | Bbb Bbb | email2@email.com |
      | Ccc Ccc | email3@email.com |
    And I am on the view visitors page
    When I follow "Update Rankings"
    And I check "Aaa Aaa"
    And I check "Bbb Bbb"
    And I press "Rank Hosts"
    And I rank the "first" host "2"
    And I rank the "second" host "1"
    And I press "Update Rankings"
    Then I should see "Visitor was successfully updated."

  Scenario: I see the visitor's name while removing him
    Given I am on the view visitors page
    When I follow "Remove"
    Then I should see "User1"

  Scenario: I remove a visitor
    Given I am on the view visitors page
    When I follow "Remove"
    And I press "Remove Visitor"
    Then I should see "Visitor was successfully removed."

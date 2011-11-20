Feature: Administrators can manage visitors

  To ensure that the visitors' information and preferences are correct
  As an administrator
  I want to manage visitors

  Background: I am signed in as an administrator
    Given the following people have been added:
      | ldap_id | role          | name           | email            |
      | ID1     | administrator | Administrator1 | email1@email.com |
      | ID2     | facilitator   | Facilitator1   | email2@email.com |
      | ID3     | user          | User1          | email3@email.com |
      | ID4     | user          | User2          | email4@email.com |
      | ID5     | user          | User3          | email5@email.com |
      | ID6     | user          | User4          | email6@email.com |
    And the following events have been added:
      | name      | meeting_length | meeting_gap | max_meetings_per_visitor |
      | Visit Day | 900            | 300         | 10                       |
      | Tapia     | 900            | 300         | 10                       |
    And I want to manage the event named "Visit Day"
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
    And the following visitors have been added to the event:
      | name  |
      | User1 |
      | User2 |
    And I am signed in as an "Administrator"

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
    Given I want to manage the visitor named "User1"
    And I am on the view visitors page
    When I follow "Edit Info" for the visitor named "User1"
    Then I should see "User1"

  Scenario: I see the visitor's name while updating his availability
    Given I want to manage the visitor named "User1"
    And I am on the view visitors page
    When I follow "Update Availability" for the visitor named "User1"
    Then I should see "User1"

  Scenario: I update an visitor's availability
    Given I want to manage the visitor named "User1"
    And I am on the view visitors page
    When I follow "Update Availability" for the host named "User1"
    And I flag the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" meeting time as available
    And I flag the "1/1/2011 10:00AM" to "1/1/2011 10:15AM" meeting time as available
    And I press "Update Availability"
    Then I should see "Visitor was successfully updated"
    And I should be on the edit visitor availability page

  Scenario: I see the visitor's name while updating his host rankings
    Given the following hosts have been added to the event:
      | name  |
      | User3 |
      | User4 |
    And I want to manage the visitor named "User1"
    And I am on the view visitors page
    When I follow "Update Rankings" for the visitor named "User1"
    And I check "User3"
    And I press "Rank Hosts"
    Then I should see "User1"

  Scenario: I update a visitor's host rankings
    Given the following hosts have been added to the event:
      | name  |
      | User3 |
      | User4 |
    And I want to manage the visitor named "User1"
    And I am on the view visitors page
    When I follow "Update Rankings" for the visitor named "User1"
    And I check "User3"
    And I check "User4"
    And I press "Rank Hosts"
    And I rank the host named "User3" "2"
    And I rank the host named "User4" "1"
    And I press "Update Rankings"
    Then I should see "Visitor was successfully updated."

  Scenario: I see the visitor's name while removing him
    Given I want to manage the visitor named "User1"
    Given I am on the view visitors page
    When I follow "Remove" for the visitor named "User1"
    Then I should see "User1"

  Scenario: I remove a visitor
    Given I want to manage the visitor named "User1"
    And I am on the view visitors page
    When I follow "Remove" for the visitor named "User1"
    And I press "Remove Visitor"
    Then I should see "Visitor was successfully removed."

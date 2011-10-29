Feature: Staff can manage hosts

  To ensure that the hosts' information and preferences are correct
  As a staff
  I want to manage hosts

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
    And the following "Hosts" have been added to the event:
      | name  |
      | User1 |
      | User2 |
    And I am registered as a "Staff"
    And I am signed in

  Scenario: I view a list of hosts
    Given I am on the view event page
    When I follow "Manage Hosts"
    Then I should be on the view hosts page
    And I should see "User1"
    And I should see "User2"

  Scenario Outline: I add a host
    Given I am on the view hosts page
    When I follow "Add Host"
    And I select "<name>" from "Person"
    And I fill in "Default Room" with "<default_room>"
    And I select "<max_visitors_per_meeting>" from "Max Visitors per Meeting"
    And I select "<max_visitors>" from "Max Total Visitors"
    And I press "Add Host"
    And I should see "<result>" 

    Scenarios: with valid information
      | name  | default_room | max_visitors_per_meeting | max_visitors | result                       |
      | User3 | 465 Soda     | 3                        | 10           | Host was successfully added. |
      | User4 | 310 Soda     | 2                        | 20           | Host was successfully added. |

  Scenario: I add hosts by importing a CSV with valid data

  Scenario: I see the host's name while updating his information
    Given I am on the view hosts page
    When I follow "Edit Info"
    Then I should see "User1"

  Scenario: I update a hosts's information
    Given I am on the view hosts page
    When I follow "Edit Info"
    And I fill in "Default Room" with "465 Soda"
    And I select "2" from "Max Visitors per Meeting"
    And I select "15" from "Max Visitors"
    And I press "Update Host"
    Then I should see "Host was successfully updated."

  Scenario: I see the host's name while updating his availability
    Given I am on the view hosts page
    When I follow "Update Availability"
    Then I should see "User1"

  Scenario: I update a host's availability
    Given I am on the view hosts page
    When I follow "Update Availability"
    And I flag the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" slot as available
    And I flag the "1/1/2011 10:00AM" to "1/1/2011 10:15AM" slot as available
    And I press "Update Availability"
    Then I should see "Host was successfully updated"
    And I should be on the edit host availability page

  Scenario: I see the host's name while updating his visitor rankings
    Given the following "Visitors" have been added:
      | name    | email            |
      | Aaa Aaa | email1@email.com |
      | Bbb Bbb | email2@email.com |
      | Ccc Ccc | email3@email.com |
    And I am on the view hosts page
    When I follow "Update Rankings"
    And I check "Aaa Aaa"
    And I check "Bbb Bbb"
    And I press "Rank Visitors"
    And I rank the "first" visitor "2"
    And I rank the "second" visitor "1"
    And I press "Update Rankings"
    Then I should see "User1"

  Scenario: I update a host's visitor rankings
    Given the following "Visitors" have been added:
      | name    | email            |
      | Aaa Aaa | email1@email.com |
      | Bbb Bbb | email2@email.com |
      | Ccc Ccc | email3@email.com |
    And I am on the view hosts page
    When I follow "Update Rankings"
    And I check "Aaa Aaa"
    And I check "Bbb Bbb"
    And I press "Rank Visitors"
    And I rank the "first" visitor "2"
    And I rank the "second" visitor "1"
    And I press "Update Rankings"
    Then I should see "Host was successfully updated."

  Scenario: I see the hosts's name while removing him
    Given I am on the view hosts page
    When I follow "Remove"
    Then I should see "User1"

  Scenario: I remove a host
    Given I am on the view hosts page
    When I follow "Remove"
    And I press "Remove Host"
    Then I should see "Host was successfully removed."
    And I should not see "User1"

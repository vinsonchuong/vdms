Feature: Administrators can manage hosts

  To ensure that the hosts' information and preferences are correct
  As an administrator
  I want to manage hosts

  Background: I am signed in as an administrator
    Given the following people have been added:
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
    And the following hosts have been added to the event:
      | name  |
      | User1 |
      | User2 |
    And I am signed in as an "Administrator"

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
    Given I want to manage the host named "User1"
    And I am on the view hosts page
    When I follow "Edit Info" for the host named "User1"
    Then I should see "User1"

  Scenario: I update a hosts's information
    Given I want to manage the host named "User1"
    And I am on the view hosts page
    When I follow "Edit Info" for the host named "User1"
    And I fill in "Default Room" with "465 Soda"
    And I select "2" from "Max Visitors per Meeting"
    And I select "15" from "Max Visitors"
    And I press "Update Host"
    Then I should see "Host was successfully updated."

  Scenario: I see the host's name while updating his availability
    Given I want to manage the host named "User1"
    And I am on the view hosts page
    When I follow "Update Availability" for the host named "User1"
    Then I should see "User1"

  Scenario: I update a host's availability
    Given I want to manage the host named "User1"
    And I am on the view hosts page
    When I follow "Update Availability" for the host named "User1"
    And I flag the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" meeting time as available
    And I flag the "1/1/2011 10:00AM" to "1/1/2011 10:15AM" meeting time as available
    And I set the room for the "1/1/2011 10:00AM" to "1/1/2011 10:15AM" meeting time to "495 Soda"
    And I press "Update Availability"
    Then I should see "Host was successfully updated"
    And I should be on the edit host availability page

  Scenario: I see the host's name while updating his visitor rankings
    Given the following visitors have been added to the event:
      | name  |
      | User3 |
      | User4 |
    And I want to manage the host named "User1"
    And I am on the view hosts page
    When I follow "Update Rankings" for the host named "User1"
    And I check "User3"
    And I press "Rank Visitors"
    Then I should see "User1"

  Scenario: I update a host's visitor rankings
    Given the following visitors have been added to the event:
      | name  |
      | User3 |
      | User4 |
    And I want to manage the host named "User1"
    And I am on the view hosts page
    When I follow "Update Rankings" for the host named "User1"
    And I check "User3"
    And I check "User4"
    And I press "Rank Visitors"
    And I rank the visitor named "User3" "2"
    And I rank the visitor named "User4" "1"
    And I flag the visitor named "User4" as mandatory
    And I flag the visitor named "User4" as one on one
    And I select "3" time slots for the visitor named "User4"
    And I press "Update Rankings"
    Then I should see "Host was successfully updated."

  Scenario: I remove a visitor from a host's rankings
    Given the following visitors have been added to the event:
      | name  |
      | User3 |
      | User4 |
    And the host named "User1" has the following rankings:
      | rank | name  | mandatory | num_time_slots | one_on_one |
      | 1    | User3 | true      | 2              | true       |
      | 2    | User4 | false     | 1              | false      |
    And I want to manage the host named "User1"
    And I am on the view hosts page
    When I follow "Update Rankings" for the host named "User1"
    And I flag the visitor named "User3" for removal
    And I press "Update Rankings"
    Then I should see "Host was successfully updated."
    And I should not see "User3"

  Scenario: I see the hosts's name while removing him
    Given I want to manage the host named "User1"
    And I am on the view hosts page
    When I follow "Remove" for the host named "User1"
    Then I should see "User1"

  Scenario: I remove a host
    Given I want to manage the host named "User1"
    And I am on the view hosts page
    When I follow "Remove" for the host named "User1"
    And I press "Remove Host"
    Then I should see "Host was successfully removed."
    And I should not see "User1"

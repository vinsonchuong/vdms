Feature: Hosts are forced to verify their info

  So that the app has accurate info to work with
  As a host
  I am forced to verify my info when viewing an event for the first time

  Background: I am signed in as a host for the event.
    Given I am signed in as a "User"
    And the following event has been added:
      | name           | meeting_length | meeting_gap | max_meetings_per_visitor |
      | Visit Day 2011 | 900            | 300         | 10                       |
    And the following host has been added to the event:
      | name    |
      | My Name |

  Scenario: I am forced to verify my info if the host is unverified
    Given the host is unverified
    And I am on the home page
    When I follow "View Event"
    Then I should be on the edit host page

  Scenario: I verify my info
    Given the host is unverified
    And I am on the home page
    When I follow "View Event"
    And I select "Computer Science" from "Division"
    And I select "Graphics" from "Area 1"
    And I select "Human-Computer Interaction" from "Area 2"
    And I fill in "Default Room" with "495 Soda"
    And I select "3" from "Max Visitors per Meeting"
    And I select "15" from "Max Visitors"
    And I press "Update My Info"
    Then I should see "Your info was successfully updated"
    And I should be on the view event page

  Scenario: I am not forced to verify my info if the host is verified
    Given I am on the home page
    When I follow "View Event"
    Then I should be on the view event page

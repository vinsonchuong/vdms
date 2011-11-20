Feature: Visitors are forced to verify their info

  So that the app has accurate info to work with
  As a visitor
  I am forced to verify my info when viewing an event for the first time

  Background: I am signed in as a visitor for the event.
    Given I am signed in as a "User"
    And the following event has been added:
      | name           | meeting_length | meeting_gap | max_meetings_per_visitor |
      | Visit Day 2011 | 900            | 300         | 10                       |
    And the following visitor has been added to the event:
      | name    |
      | My Name |

  Scenario: I am forced to verify my info if the visitor is unverified
    Given the visitor is unverified
    And I am on the home page
    When I follow "View Event"
    Then I should be on the edit visitor page

  Scenario: I verify my info
    Given the visitor is unverified
    And I am on the home page
    When I follow "View Event"
    And I press "Update My Info"
    Then I should see "Your info was successfully updated"
    And I should be on the view event page

  Scenario: I am not forced to verify my info if the host is verified
    Given I am on the home page
    When I follow "View Event"
    Then I should be on the view event page

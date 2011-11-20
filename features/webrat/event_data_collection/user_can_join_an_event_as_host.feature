Feature: User can join an event as host

  So that I can be a host for the event
  As a user
  I want to join the event

  Background: I am signed in as a user
    Given I am signed in as a "User"
    And the following event has been added:
      | name           | meeting_length | meeting_gap | max_meetings_per_visitor |
      | Visit Day 2011 | 900            | 300         | 10                       |

  Scenario: I join the event
    Given I am on the home page
    When I follow "Join Event" for the event named "Visit Day 2011"
    And I press "Join Event"
    And I fill in "Name" with "My Name"
    And I fill in "Email" with "myemail@email.com"
    And I fill in "Default Room" with "465 Soda"
    And I select "2" from "Max Visitors per Meeting"
    And I select "5" from "Max Visitors"
    And I press "Update My Info"
    Then I should see "Your info was successfully updated"
    And I should be on the view event page

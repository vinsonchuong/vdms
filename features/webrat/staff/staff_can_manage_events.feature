Feature: Staff can manage events

  So that I can schedule upcoming events
  As a staff
  I want to manage events

  Background: I am signed in as a staff
    Given the following events have been added:
      | name      | meeting_length | meeting_gap | max_meetings_per_visitor |
      | Tapia     | 900            | 300         | 10                       |
      | Visit Day | 900            | 300         | 10                       |
    Given I am registered as a "Staff"
    And I am signed in

  Scenario: I view a list of all events
    Given I am on the home page
    Then I should see "Tapia"
    And I should see "Visit Day"

  Scenario: I view an event
    Given I am on the home page
    When I follow "View Event"
    Then I should be on the view event page
    And I should see "Tapia"

  Scenario Outline: I add an event
    Given I am on the home page
    When I follow "Add Event"
    And I fill in "Name" with "<name>"
    And I fill in "Meeting Length" with "<meeting_length>"
    And I fill in "Inter-Meeting Gap" with "<meeting_gap>"
    And I press "Add Event"
    Then I should see "<result>"

    Scenarios: with valid information
      | name  | meeting_length | meeting_gap | max_meetings_per_visitor | result                        |
      | Event | 1200           | 300         | 8                        | Event was successfully added. |
      | Event | 1200           | 0           | 8                        | Event was successfully added. |

    Scenarios: with invalid information
      | name  | meeting_length | meeting_gap | max_meetings_per_visitor | result                                     |
      |       | 1200           | 300         | 8                        | Name can't be blank                        |
      | Event |                | 300         | 8                        | Meeting Length can't be blank              |
      | Event | 1200           |             | 8                        | Inter-Meeting Gap can't be blank           |

  Scenario: I edit an event
    Given I am on the home page
    When I follow "Edit Event"
    And I fill in "Meeting Length" with "1800"
    And I fill in "Inter-Meeting Gap" with "0"
    And I press "Update Event"
    Then I should see "Event was successfully updated"

  Scenario: I specify the meeting time ranges
    Given I am on the edit event page
    When I add "January 1, 2011 10:00AM" to "12:00PM" to the meeting times
    And I add "January 1, 2011 1:00PM" to "2:00PM" to the meeting times
    And I press "Update Event"
    Then I should see "Event was successfully updated."
    And there should be a meeting time beginning with "1/1/2011 10:00AM"

  Scenario: I remove a meeting time range
    Given the event has the following meeting times:
      | begin           | end              |
      | 1/1/2000 9:00AM | 1/1/2000 12:00PM |
      | 1/1/2000 2:00PM | 1/1/2000 3:00PM  |
    And I am on the edit event page
    When I remove the meeting time beginning with "1/1/2000 9:00AM"
    And I press "Update Event"
    Then I should see "Event was successfully updated."
    And there should not be a meeting time beginning with "1/1/2000 9:00AM"

  Scenario: I prevent hosts and facilitators from making further changes to availabilities and rankings
    Given I am on the edit event page
    When I check "Prevent Updates by Facilitators"
    And I check "Prevent Updates by Hosts"
    And I press "Update Event"
    Then I should see "Event was successfully updated."

  Scenario: I remove an event
    Given I am on the home page
    When I follow "Remove Event"
    And I press "Remove Event"
    Then I should see "Event was successfully removed"

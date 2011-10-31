Feature: Administrators can manage events

  So that I can schedule upcoming events
  As an administrator
  I want to manage events

  Background: I am signed in as an administrator
    Given the following events have been added:
      | name           | meeting_length | meeting_gap | max_meetings_per_visitor |
      | Tapia          | 900            | 300         | 10                       |
      | Visit Day 2011 | 900            | 300         | 10                       |
    And I am signed in as an "Administrator"

  Scenario: I view a list of all events
    Given I am on the home page
    Then I should see "Tapia"
    And I should see "Visit Day 2011"

  Scenario: I view an event
    Given I want to manage the event named "Visit Day 2011"
    And I am on the home page
    When I follow "View Event" for the event named "Visit Day 2011"
    Then I should be on the view event page
    And I should see "Visit Day 2011"

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
    Given I want to manage the event named "Visit Day 2011"
    And I am on the home page
    When I follow "Edit Event" for the event named "Visit Day 2011"
    And I fill in "Meeting Length" with "1800"
    And I fill in "Inter-Meeting Gap" with "0"
    And I press "Update Event"
    Then I should see "Event was successfully updated"

  Scenario: I specify the meeting time ranges
    Given I want to manage the event named "Visit Day 2011"
    And I am on the edit event page
    When I add "January 1, 2011 10:00AM" to "12:00PM" to the meeting times
    And I add "January 1, 2011 1:00PM" to "2:00PM" to the meeting times
    And I press "Update Event"
    Then I should see "Event was successfully updated."
    And there should be a "1/1/2011 10:00AM" to "1/1/2011 12:00PM" meeting time

  Scenario: I remove a meeting time range
    Given I want to manage the event named "Visit Day 2011"
    And the event has the following meeting times:
      | begin           | end              |
      | 1/1/2000 9:00AM | 1/1/2000 12:00PM |
      | 1/1/2000 2:00PM | 1/1/2000 3:00PM  |
    And I am on the edit event page
    When I remove the "1/1/2000 9:00AM" to "1/1/2000 12:00PM" meeting time
    And I press "Update Event"
    Then I should see "Event was successfully updated."
    And there should not be a "1/1/2011 9:00AM" to "1/1/2011 12:00PM" meeting time

  Scenario: I prevent hosts and facilitators from making further changes to availabilities and rankings
    Given I want to manage the event named "Visit Day 2011"
    And I am on the edit event page
    When I check "Prevent Updates by Facilitators"
    And I check "Prevent Updates by Hosts"
    And I press "Update Event"
    Then I should see "Event was successfully updated."

  Scenario: I remove an event
    Given I want to manage the event named "Visit Day 2011"
    And I am on the home page
    When I follow "Remove Event" for the event named "Visit Day 2011"
    And I press "Remove Event"
    Then I should see "Event was successfully removed"

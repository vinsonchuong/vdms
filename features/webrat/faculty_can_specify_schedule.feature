Feature: Faculty can specify schedule

  So that I can make my meeting preferences and availability known
  As a faculty
  I want to specify my meeting schedule

  Background: I am signed in as a faculty
    Given I am registered as a "Faculty" in "Computer Science"
    And I am signed in

  Scenario: I can specify my schedule
    Given I am on the faculty dashboard page
    When I follow "Update Meeting Availability"
    Then I should be on the schedule faculty page

  Scenario: I specify a default meeting room
    Given I am on the schedule faculty page
    When I fill in "Default room" with "373 Soda"
    And I press "Save Changes"
    Then I should see "Meeting availability was successfully updated"

  Scenario: I specify the maximum number of students per meeting slot
    Given I am on the schedule faculty page
    When I fill in "Max admits per meeting" with "4"
    And I press "Save Changes"
    Then I should see "Meeting availability was successfully updated"

  Scenario: I specify the meeting slots for which I am available
    Given "Computer Science" has the following meeting times:
      | begin           | end              |
      | 1/1/2011 9:00AM | 1/1/2011 11:00AM |
      | 1/1/2011 2:00PM | 1/1/2011 02:45PM |
    And I am on the schedule faculty page
    When I flag the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" slot as available
    And I flag the "1/1/2011 10:00AM" to "1/1/2011 10:15AM" slot as available
    And I press "Save changes"
    Then I should see "Meeting availability was successfully updated"

  Scenario: I specify a different room for a meeting slot
    Given "Computer Science" has the following meeting times:
      | begin           | end              |
      | 1/1/2011 9:00AM | 1/1/2011 11:00AM |
      | 1/1/2011 2:00PM | 1/1/2011 02:45PM |
    And I am on the schedule faculty page
    When I flag the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" slot as available
    And I set the room for the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" slot to "373 Soda"
    And I flag the "1/1/2011 10:00AM" to "1/1/2011 10:15AM" slot as available
    And I set the room for the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" slot to "373 Soda"
    And I press "Save changes"
    Then I should see "Meeting availability was successfully updated"

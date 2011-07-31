Feature: Faculty can specify availability

  So that I can make my meeting preferences and availability known
  As a faculty
  I want to specify my meeting availability

  Background: I am signed in as a faculty
    Given the event has the following meeting time slots:
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
    And I am registered as a "Faculty" in "Computer Science"
    And I am signed in

  Scenario: I can specify my schedule
    Given I am on the faculty dashboard page
    When I follow "Update My Availability"
    Then I should be on the update faculty availability page

  Scenario: I specify a default meeting room
    Given I am on the update faculty availability page
    When I fill in "Default room" with "373 Soda"
    And I press "Update Availability"
    Then I should see "Host was successfully updated"
    And I should be on the update faculty availability page

  Scenario: I specify the maximum number of students per meeting slot
    Given I am on the update faculty availability page
    When I fill in "Max visitors per meeting" with "4"
    And I press "Update Availability"
    Then I should see "Host was successfully updated"
    And I should be on the update faculty availability page

  Scenario: I specify the meeting slots for which I am available
    Given I am on the update faculty availability page
    When I flag the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" slot as available
    And I flag the "1/1/2011 10:00AM" to "1/1/2011 10:15AM" slot as available
    And I press "Update Availability"
    Then I should see "Host was successfully updated"
    And I should be on the update faculty availability page

  Scenario: I specify a different room for a meeting slot
    Given I am on the update faculty availability page
    When I flag the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" slot as available
    And I set the room for the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" slot to "373 Soda"
    And I flag the "1/1/2011 10:00AM" to "1/1/2011 10:15AM" slot as available
    And I set the room for the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" slot to "373 Soda"
    And I press "Update Availability"
    Then I should see "Host was successfully updated"
    And I should be on the update faculty availability page

  Scenario: The staff have disabled making further changes
    Given the staff have disabled faculty from making further changes
    When I go to the rank admits page
    Then I should see "The Staff have disabled making further changes."

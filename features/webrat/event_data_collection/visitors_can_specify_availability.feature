Feature: Visitors can specify availability

  So that the app can schedule meetings for me
  As a visitor
  I want to specify my meeting availability

  Background: I am signed in as a visitor
    Given I am signed in as a "User"
    And the following event has been added:
      | name           | meeting_length | meeting_gap | max_meetings_per_visitor |
      | Visit Day 2011 | 900            | 300         | 10                       |
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
    And the following visitor has been added to the event:
      | name    |
      | My Name |

  Scenario: I can specify my availability
    Given I am on the view event page
    When I follow "Update My Availability"
    Then I should be on the edit visitor availability page

  Scenario: I specify the meeting slots for which I am available
    Given I am on the edit visitor availability page
    When I flag the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" meeting time as available
    And I flag the "1/1/2011 10:00AM" to "1/1/2011 10:15AM" meeting time as available
    And I press "Update Availability"
    Then I should see "Your info was successfully updated"
    And I should be on the edit visitor availability page

  Scenario: The administrators have disabled making further changes

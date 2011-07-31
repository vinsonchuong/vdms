Feature: Peer advisor can specify admit availability

  So that I can specify the meeting availability for my admits
  As a peer advisor
  I want to update an admit's availability

  Background: I am signed in as a peer advisor and my admits are registered
    Given I am registered as a "Peer Advisor"
    And I am signed in
    And the following "Admits" have been added:
      | first_name  | last_name  | email            | phone      | division               | area1                      | area2                   |
      | First1      | Last1      | email1@email.com | 1234567891 | Computer Science       | Theory                     | Artificial Intelligence |
      | First2      | Last2      | email2@email.com | 1234567892 | Computer Science       | Human-Computer Interaction | Graphics                |
      | First3      | Last3      | email3@email.com | 1234567893 | Electrical Engineering | Energy                     | Physical Electronics    |
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
      | 1/1/2011 12:00PM | 1/1/2011 12:15PM |
      | 1/1/2011 12:15PM | 1/1/2011 12:30PM |
      | 1/1/2011 12:30PM | 1/1/2011 12:45PM |
      | 1/1/2011 12:45PM | 1/1/2011 01:00PM |
      | 1/1/2011 01:00PM | 1/1/2011 01:15PM |
      | 1/1/2011 01:15PM | 1/1/2011 01:30PM |
      | 1/1/2011 01:30PM | 1/1/2011 01:45PM |
      | 1/1/2011 01:45PM | 1/1/2011 02:00PM |
      | 1/1/2011 02:00PM | 1/1/2011 02:15PM |
      | 1/1/2011 02:15PM | 1/1/2011 02:30PM |
      | 1/1/2011 02:30PM | 1/1/2011 02:45PM |
      | 1/1/2011 02:45PM | 1/1/2011 03:00PM |

  Scenario: I update an admit's availability
    Given I am on the view admits page
    When I follow "Update Availability" for the first admit
    When I flag the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" slot as available
    And I flag the "1/1/2011 12:00PM" to "1/1/2011 12:15PM" slot as available
    And I press "Update Availability"
    Then I should see "Visitor was successfully updated"
    And I should be on the update admit availability page

  Scenario: I see the admit's name
    Given I am on the view admits page
    When I follow "Update Availability" for the first admit
    Then I should see "First1 Last1"

  Scenario: The staff have disabled making further changes
    Given the staff have disabled peer advisors from making further changes
    And I am on the view admits page
    When I follow "Update Availability" for the first admit
    Then I should see "The Staff have disabled making further changes."

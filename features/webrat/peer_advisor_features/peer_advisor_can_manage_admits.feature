Feature: Peer advisor can manage admits

  So that I can specify the preferences and availability of my admits
  As a peer advisor
  I want to manage admits

  Background: I am signed in as a peer advisor and my admits are registered
    Given I am registered as a "Peer Advisor"
    And I am signed in
    And the following "Admits" have been added:
      | first_name  | last_name  | email            | phone      | division               | area1                      | area2    |
      | First1      | Last1      | email1@email.com | 1234567891 | Computer Science       | Artificial Intelligence    | Theory   |
      | First2      | Last2      | email2@email.com | 1234567892 | Computer Science       | Human-Computer Interaction | Graphics |
      | First3      | Last3      | email3@email.com | 1234567893 | Electrical Engineering | Physical Electronics       | Energy   |

  Scenario: I can manage admits
    Given I am on the peer advisor dashboard page
    When I follow "Manage Admits"
    Then I should be on the view admits page

  Scenario: I view a list of all admits
    When I go to the view admits page
    And I should see "First1"
    And I should see "Last1"
    And I should see "Artificial Intelligence"
    And I should see "First2"
    And I should see "Last2"
    And I should see "Human-Computer Interaction"
    And I should see "First3"
    And I should see "Last3"
    And I should see "Physical Electronics"

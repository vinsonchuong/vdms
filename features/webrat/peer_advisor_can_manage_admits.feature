Feature: Peer advisor can manage admits

  So that I can specify the preferences and availability of my admits
  As a peer advisor
  I want to manage admits

  Background: I am signed in as a peer advisor and my admits are registered
    Given I am registered as a "Peer Advisor"
    And I am signed in
    And the following "Admits" have been added:
      | first_name  | last_name  | email            | phone      | area1   | area2   |
      | First1      | Last1      | email1@email.com | 1234567891 | Area 11 | Area 21 |
      | First2      | Last2      | email2@email.com | 1234567892 | Area 12 | Area 22 |
      | First3      | Last3      | email3@email.com | 1234567893 | Area 13 | Area 23 |

  Scenario: I can manage admits
    Given I am on the peer advisor dashboard page
    When I follow "Manage Admits"
    Then I should be on the view admits page

  Scenario: I view a list of all admits
    When I go to the view admits page
    And I should see "First1"
    And I should see "Last1"
    And I should see "Area 11"
    And I should see "First2"
    And I should see "Last2"
    And I should see "Area 12"
    And I should see "First3"
    And I should see "Last3"
    And I should see "Area 13"

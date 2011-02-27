Feature: Peer advisor can update admit information

  So that my admits' information is up to date
  As a peer advisor
  I want to update my admits' information

  Background: I am signed in as a peer advisor and my admits are registered
    Given I am registered as a "Peer Advisor"
    And I am signed in
    And the following "Admits" have been added:
      | first_name  | last_name  | email            | phone      | division               | area1                      | area2    |
      | First1      | Last1      | email1@email.com | 1234567891 | Computer Science       | Artificial Intelligence    | Theory   |
      | First2      | Last2      | email2@email.com | 1234567892 | Computer Science       | Human-Computer Interaction | Graphics |
      | First3      | Last3      | email3@email.com | 1234567893 | Electrical Engineering | Physical Electronics       | Energy   |

  Scenario: I see the admit's name
    Given I am on the view admits page
    When I follow "Update Info" for the first admit
    Then I should see "First1 Last1"

  Scenario: I update the information of one of my admits
    Given I am on the view admits page
    When I follow "Update Info"
    And I fill in "Email" with "new_email@email.com"
    And I fill in "Phone Number" with "1234567890"
    And I press "Update Admit"
    Then I should see "Admit was successfully updated."

  Scenario: I try to update an admit with invalid information
    Given I am on the view admits page
    When I follow "Update Info"
    And I fill in "First Name" with ""
    And I press "Update Admit"
    Then I should see "First Name can't be blank"

  Scenario: I try to update an admit with invalid information twice
    Given I am on the view admits page
    When I follow "Update Info"
    And I fill in "First Name" with ""
    And I press "Update Admit"
    And I press "Update Admit"
    Then I should see "First Name can't be blank"

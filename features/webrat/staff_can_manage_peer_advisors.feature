Feature: Staff can manage peer advisors

  So that peer advisors can manage meeting scheduling on behalf of their admits
  As a staff
  I want to add peer advisors to the app

  Background: I am signed in as a staff
    Given I am registered as a "Staff"
    And I am signed in

  Scenario: I can manage peer advisors
    Given I am on the staff dashboard page
    When I follow "Manage Peer Advisors"
    Then I should be on the view peer advisors page

  Scenario: I view a list of all staff

  Scenario Outline: I add a peer advisor
    Given I am on the view peer advisors page
    When I follow "Add Peer Advisor"
    And I fill in "CalNet ID" with "<calnet_id>"
    And I fill in "First Name" with "<first_name>"
    And I fill in "Last Name" with "<last_name>"
    And I fill in "Email" with "<email>"
    And I press "Save changes"
    And I should see "<result>" 

    Scenarios: with valid information
      | calnet_id   | first_name | last_name | email           | result                               |
      | test-212387 | First      | Last      | email@email.com | Peer Advisor was successfully added. |

    Scenarios: with invalid information
      | calnet_id   | first_name | last_name | email           | result                               |
      | test-212387 | First      | Last      | invalid_email   | Email is invalid                     | 

  Scenario: I add peer advisors via CSV import

  Scenario: I view a list of peer advisors

  Scenario: I update a peer advisor's information

  Scenario: I remove a peer advisor

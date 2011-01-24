Feature: Staff can manage staff

  So that other staff can manage scheduling for visit day
  As a staff
  I want to add other staff to the app

  Background: I am signed in as a staff
    Given I am registered as a "Staff"
    And I am signed in

  Scenario: I can manage staff
    Given I am on the staff dashboard page
    When I follow "Manage Staff"
    Then I should be on the view staff page

  Scenario: I view a list of all staff

  Scenario Outline: I add a staff
    Given I am on the view staff page
    When I follow "Add Staff"
    And I fill in "CalNet ID" with "<calnet_id>"
    And I fill in "First Name" with "<first_name>"
    And I fill in "Last Name" with "<last_name>"
    And I fill in "Email" with "<email>"
    And I press "Save changes"
    And I should see "<result>" 

    Scenarios: with valid information
      | calnet_id   | first_name | last_name | email           | result                        |
      | test-212387 | First      | Last      | email@email.com | Staff was successfully added. |

    Scenarios: with invalid information
      | calnet_id   | first_name | last_name | email           | result                        |
      | test-212387 | First      | Last      | invalid_email   | Email is invalid              |

  Scenario: I add staff via CSV import

  Scenario: I view a list of staff

  Scenario: I update a staff's information

  Scenario: I remove a staff

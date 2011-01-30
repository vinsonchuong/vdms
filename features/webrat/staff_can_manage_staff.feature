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
    Given the following "Staff" have been added:
      | calnet_id | first_name  | last_name  | email            |
      | ID1       | First1      | Last1      | email1@email.com |
      | ID2       | First2      | Last2      | email2@email.com |
      | ID3       | First3      | Last3      | email3@email.com |
    When I go to the view staff page
    Then I should see "ID1"
    And I should see "First1"
    And I should see "Last1"
    And I should see "ID2"
    And I should see "First2"
    And I should see "Last2"
    And I should see "ID3"
    And I should see "First3"
    And I should see "Last3"

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

  Scenario: I add staff by importing a CSV with valid data
    Given I am on the view staff page
    When I follow "Import Staff"
    And I attach the file "features/assets/valid_staff.csv" to "CSV File"
    And I press "Import"
    Then I should see "Staffs were successfully imported."
    And I should see "ID1"
    And I should see "ID2"
    And I should see "ID3"

  Scenario: I try to add staff by importing a CSV with some invalid data
    Given I am on the view staff page
    When I follow "Import Staff"
    And I attach the file "features/assets/invalid_staff.csv" to "CSV File"
    And I press "Import"
    Then I should see "Calnet can't be blank"
    And I should see "First name can't be blank"
    And I should see "Email can't be blank"

  Scenario: I update a staff's information

  Scenario: I remove a staff

Feature: Staff can manage faculty

  So that faculty can specify their meeting preferences and admits can specify theirs
  As a staff
  I want to add faculty to the app

  Background: I am signed in as a staff
    Given I am registered as a "Staff"
    And I am signed in

  Scenario: I can manage faculty
    Given I am on the staff dashboard page
    When I follow "Manage Faculty"
    Then I should be on the view faculty page

  Scenario: I view a list of all faculty
    Given the following "Faculty" have been added:
      | calnet_id | first_name  | last_name  | email            | area  | division               |
      | ID1       | First1      | Last1      | email1@email.com | Area1 | Computer Science       |
      | ID2       | First2      | Last2      | email2@email.com | Area2 | Electrical Engineering |
      | ID3       | First3      | Last3      | email3@email.com | Area3 | Computer Science       |
    When I go to the view faculty page
    Then I should see "ID1"
    And I should see "First1"
    And I should see "Last1"
    And I should see "Area1"
    And I should see "ID2"
    And I should see "First2"
    And I should see "Last2"
    And I should see "Area2"
    And I should see "ID3"
    And I should see "First3"
    And I should see "Last3"
    And I should see "Area3"

  Scenario Outline: I add a faculty
    Given I am on the view faculty page
    When I follow "Add Faculty"
    And I fill in "CalNet ID" with "<calnet_id>"
    And I fill in "First Name" with "<first_name>"
    And I fill in "Last Name" with "<last_name>"
    And I fill in "Email" with "<email>"
    And I fill in "Area" with "<area>"
    And I fill in "Division" with "<division>"
    And I press "Save changes"
    And I should see "<result>" 

    Scenarios: with valid information
      | calnet_id   | first_name | last_name | email           | area | division               | result                        |
      | test-212387 | First      | Last      | email@email.com | Area | Computer Science       | Faculty was successfully added. |
      | test-212387 | First      | Last      | email@email.com | Area | Electrical Engineering | Faculty was successfully added. |

    Scenarios: with invalid information
      | calnet_id   | first_name | last_name | email           | area | division               | result                        |
      | test-212387 | First      | Last      | invalid_email   | Area | Computer Science       | Email is invalid              |
      | test-212387 | First      | Last      | invalid_email   | Area | Invalid Division       | Email is invalid              |

  Scenario: I add faculty by importing a CSV with valid data
    Given I am on the view faculty page
    When I follow "Import Faculty"
    And I attach the file "features/assets/valid_faculty.csv" to "CSV File"
    And I press "Import"
    Then I should see "Faculties were successfully imported."
    And I should see "ID1"
    And I should see "ID2"
    And I should see "ID3"

  Scenario: I try to add faculty by importing a CSV with some invalid data
    Given I am on the view faculty page
    When I follow "Import Faculty"
    And I attach the file "features/assets/invalid_faculty.csv" to "CSV File"
    And I press "Import"
    Then I should see "Calnet can't be blank"
    And I should see "Area can't be blank"
    And I should see "Division is not included in the list"

  Scenario: I update a faculty's information

  Scenario: I update a faculty's schedule

  Scenario: I update a faculty's admit rankings and preferences

  Scenario: I remove a faculty

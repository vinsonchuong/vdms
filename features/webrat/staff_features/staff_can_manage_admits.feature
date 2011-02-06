@staff_can_manage_admits
Feature: Staff can manage admits

  So that peer advisors can specify the meeting preferences of their admits and faculty can specify theirs
  As a staff
  I want to add admits to the app

  Background: I am signed in as a staff
    Given I am registered as a "Staff"
    And I am signed in

  Scenario: I can manage admits
    Given I am on the staff dashboard page
    When I follow "Manage Admits"
    Then I should be on the view admits page

  Scenario: I view a list of all admits
    Given the following "Admits" have been added:
      | first_name  | last_name  | email            | phone      | area1   | area2   |
      | First1      | Last1      | email1@email.com | 1234567891 | Area 11 | Area 21 |
      | First2      | Last2      | email2@email.com | 1234567892 | Area 12 | Area 22 |
      | First3      | Last3      | email3@email.com | 1234567893 | Area 13 | Area 23 |
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

  Scenario Outline: I add an admit
    Given I am on the view admits page
    When I follow "Add Admit"
    And I fill in "First Name" with "<first_name>"
    And I fill in "Last Name" with "<last_name>"
    And I fill in "Email" with "<email>"
    And I fill in "Phone" with "<phone>"
    And I fill in "Area 1" with "<area1>"
    And I fill in "Area 2" with "<area2>"
    And I press "Save changes"
    And I should see "<result>" 

    Scenarios: with valid information
      | first_name | last_name | email           | phone          | area1  | area2  | result                        |
      | First      | Last      | email@email.com | 123-456-7890   | Area 1 | Area 2 | Admit was successfully added. |
      | First      | Last      | email@email.com | 123.456.7890   | Area 1 | Area 2 | Admit was successfully added. |
      | First      | Last      | email@email.com | (123) 456-7890 | Area 1 | Area 2 | Admit was successfully added. |
      | First      | Last      | email@email.com | 1234567890     | Area 1 | Area 2 | Admit was successfully added. |

    Scenarios: with invalid information
      | first_name | last_name | email           | result                                                           |
      | First      | Last      | invalid_email   | Email is invalid                                                 |
      | First      | Last      | invalid_phone   | Phone must be a valid numeric US phone number                    |
      | First      | Last      | 123-4567        | Phone must be a valid numeric US phone number                    |
      | First      | Last      | 1-123-456-7890  | Phone must be a valid numeric US phone number                    |

  Scenario: I add admits by importing a CSV with valid data
    Given I am on the view admits page
    When I follow "Import Admits"
    And I attach the file "features/assets/valid_admits.csv" to "CSV File"
    And I press "Import"
    Then I should see "Admits were successfully imported."
    And I should see "First1"
    And I should see "First2"
    And I should see "First3"

  Scenario: I try to add admits by importing a CSV with some invalid data
    Given I am on the view admits page
    When I follow "Import Admits"
    And I attach the file "features/assets/invalid_admits.csv" to "CSV File"
    And I press "Import"
    Then I should see "Email can't be blank"
    And I should see "Phone can't be blank"
    And I should see "Area1 can't be blank"

  Scenario: I update an admit's information

  Scenario: I update an admit's meeting availability

  Scenario: I update an admit's faculty rankings

  Scenario: I remove an admit

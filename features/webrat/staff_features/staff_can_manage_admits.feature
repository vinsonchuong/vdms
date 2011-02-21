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
      | first_name  | last_name  | email            | phone      | area1                       | area2    |
      | First1      | Last1      | email1@email.com | 1234567891 | Theory                      | Graphics |
      | First2      | Last2      | email2@email.com | 1234567892 | Communications & Networking | Energy   |
      | First3      | Last3      | email3@email.com | 1234567893 | Human-Computer Interaction  | Graphics |
    When I go to the view admits page
    And I should see "First1"
    And I should see "Last1"
    And I should see "Theory"
    And I should see "First2"
    And I should see "Last2"
    And I should see "Communications & Networking"
    And I should see "First3"
    And I should see "Last3"
    And I should see "Human-Computer Interaction"

  Scenario Outline: I add an admit
    Given I am on the view admits page
    When I follow "Add Admit"
    And I fill in "First Name" with "<first_name>"
    And I fill in "Last Name" with "<last_name>"
    And I fill in "Email" with "<email>"
    And I fill in "Phone" with "<phone>"
    And I select "<area1>" from "Area 1"
    And I select "<area2>" from "Area 2"
    And I press "Add Admit"
    And I should see "<result>" 

    Scenarios: with valid information
      | first_name | last_name | email           | phone          | area1                       | area2             | result                        |
      | First      | Last      | email@email.com | 123-456-7890   | Artificial Intelligence     | Theory            | Admit was successfully added. |
      | First      | Last      | email@email.com | 123.456.7890   | Human-Computer Interaction  | Graphics          | Admit was successfully added. |
      | First      | Last      | email@email.com | (123) 456-7890 | Communications & Networking | Energy            | Admit was successfully added. |
      | First      | Last      | email@email.com | 1234567890     | Physical Electronics        | Signal Processing | Admit was successfully added. |

    Scenarios: with invalid information
      | first_name | last_name | email           | phone           | area1                       | area2             | result                                                           |

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
    And I should see "Area 1 is not included in the list"

  Scenario: I update an admit's information

  Scenario: I update an admit's meeting availability

  Scenario: I update an admit's faculty rankings

  Scenario: I remove an admit

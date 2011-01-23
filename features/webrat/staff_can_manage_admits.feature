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

  Scenario Outline: I add an admit
    Given I am on the view admits page
    When I follow "Add Admit"
    And I fill in "CalNet ID" with "<calnet_id>"
    And I fill in "First Name" with "<first_name>"
    And I fill in "Last Name" with "<last_name>"
    And I fill in "Email" with "<email>"
    And I fill in "Phone" with "<phone>"
    And I fill in "Area 1" with "<area1>"
    And I fill in "Area 2" with "<area2>"
    And I press "Save changes"
    And I should see "<result>" 

    Scenarios: with valid information
      | calnet_id   | first_name | last_name | email           | phone          | area1  | area2  | result                        |
      | test-212387 | First      | Last      | email@email.com | 123-456-7890   | Area 1 | Area 2 | Admit was successfully added. |
      | test-212387 | First      | Last      | email@email.com | 123.456.7890   | Area 1 | Area 2 | Admit was successfully added. |
      | test-212387 | First      | Last      | email@email.com | (123) 456-7890 | Area 1 | Area 2 | Admit was successfully added. |
      | test-212387 | First      | Last      | email@email.com | 1234567890     | Area 1 | Area 2 | Admit was successfully added. |

    Scenarios: with invalid information
      | calnet_id   | first_name | last_name | email           | result                                                           |
      | test-212387 | First      | Last      | invalid_email   | Email is invalid                                                 |
      | test-212387 | First      | Last      | invalid_phone   | Phone must be a valid numeric US phone number                    |
      | test-212387 | First      | Last      | 123-4567        | Phone must be a valid numeric US phone number                    |
      | test-212387 | First      | Last      | 1-123-456-7890  | Phone must be a valid numeric US phone number                    |

  Scenario: I add admits via CSV import

  Scenario: I view a list of admits

  Scenario: I update an admit's information

  Scenario: I update an admit's meeting availability

  Scenario: I update an admit's faculty rankings

  Scenario: I remove an admit

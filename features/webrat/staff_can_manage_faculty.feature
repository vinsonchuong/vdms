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

  Scenario: I add faculty via CSV import

  Scenario: I view a list of faculty

  Scenario: I update a faculty's information

  Scenario: I update a faculty's schedule

  Scenario: I update a faculty's admit rankings and preferences

  Scenario: I remove a faculty

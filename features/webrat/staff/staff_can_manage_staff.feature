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
      | ldap_id | first_name  | last_name  | email            |
      | ID0     | First1      | Last1      | email1@email.com |
      | ID1     | First2      | Last2      | email2@email.com |
      | ID2     | First3      | Last3      | email3@email.com |
    When I go to the view staff page
    And I should see "First1"
    And I should see "Last1"
    And I should see "First2"
    And I should see "Last2"
    And I should see "First3"
    And I should see "Last3"

  Scenario Outline: I add a staff
    Given I am on the view staff page
    When I follow "Add Staff"
    And I fill in "CalNet UID" with "<ldap_id>"
    And I fill in "First Name" with "<first_name>"
    And I fill in "Last Name" with "<last_name>"
    And I fill in "Email" with "<email>"
    And I press "Add Staff"
    And I should see "<result>" 

    Scenarios: with valid information
      | ldap_id | first_name | last_name | email           | result                        |
      | ldap_id | First      | Last      | email@email.com | Staff was successfully added. |

    Scenarios: with invalid information
      | ldap_id | first_name | last_name | email           | result                        |
      | ldap_id | First      | Last      | invalid_email   | Email is invalid              |

  Scenario: I update a staff's information

  Scenario: I remove a staff

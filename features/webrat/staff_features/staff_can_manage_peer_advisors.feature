@staff_can_manage_peer_advisors
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

  Scenario: I view a list of all peer advisors
    Given the following "Peer Advisors" have been added:
      | first_name  | last_name  | email            |
      | First1      | Last1      | email1@email.com |
      | First2      | Last2      | email2@email.com |
      | First3      | Last3      | email3@email.com |
    When I go to the view peer advisors page
    And I should see "First1"
    And I should see "Last1"
    And I should see "First2"
    And I should see "Last2"
    And I should see "First3"
    And I should see "Last3"

  Scenario Outline: I add a peer advisor
    Given I am on the view peer advisors page
    When I follow "Add Peer Advisor"
    And I fill in "LDAP ID" with "<ldap_id>"
    And I fill in "First Name" with "<first_name>"
    And I fill in "Last Name" with "<last_name>"
    And I fill in "Email" with "<email>"
    And I press "Save changes"
    And I should see "<result>" 

    Scenarios: with valid information
      | ldap_id | first_name | last_name | email           | result                               |
      | ID1     | First      | Last      | email@email.com | Peer Advisor was successfully added. |

    Scenarios: with invalid information
      | ldap_id | first_name | last_name | email           | result                               |
      | ID1     | First      | Last      | invalid_email   | Email is invalid                     |

  Scenario: I add peer advisors by importing a CSV with valid data
    Given I am on the view peer advisors page
    When I follow "Import Peer Advisors"
    And I attach the file "features/assets/valid_peer_advisors.csv" to "CSV File"
    And I press "Import"
    Then I should see "Peer Advisors were successfully imported."
    And I should see "First1"
    And I should see "First2"
    And I should see "First3"

  Scenario: I try to add peer advisors by importing a CSV with some invalid data
    Given I am on the view peer advisors page
    When I follow "Import Peer Advisors"
    And I attach the file "features/assets/invalid_peer_advisors.csv" to "CSV File"
    And I press "Import"
    Then I should see "Last name can't be blank"
    And I should see "First name can't be blank"
    And I should see "Email can't be blank"

  Scenario: I update a peer advisor's information

  Scenario: I remove a peer advisor

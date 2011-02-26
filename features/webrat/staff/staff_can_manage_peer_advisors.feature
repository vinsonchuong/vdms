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

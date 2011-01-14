Feature: Staff can sign in

  So that I can manage scheduling for Visit Day
  As a staff
  I want to sign in to the app 

  Background: I am registered as a staff
    Given I am not signed in
    And I am registered as a "staff"

  Scenario: I sign in with valid credentials
    When I go to the home page
    And I follow "Staff"
    And I fill in my CalNet account information
    And I press "Authenticate"
    Then I should be on the staff dashboard page

  Scenario: I sign in with invalid credentials
    When I go to the home page
    And I follow "Staff"
    And I fill in invalid CalNet account information
    And I press "Authenticate"
    Then I should see "The CalNet ID and/or Passphrase you provided are incorrect."
    And I should be unable to access the staff dashboard page

  Scenario Outline: I am asked to sign in
    When I go to the <page> page
    Then I should be asked to sign in

    Scenarios:
      | page            |
      | staff dashboard |

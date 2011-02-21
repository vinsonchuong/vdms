Feature: Peer advisor can register

  So that I can indicate my students' meeting preferences
  As a peer advisor
  I want to sign in to the app

  Background: I am signed in
    Given I am a "Grad Student"
    And I am signed in

  Scenario: I am forced to verify my info
    Given I am on the home page
    When I follow "For Peer Advisors"
    Then I should be on the new peer advisor page

  Scenario: I verify my info
    Given I am on the home page
    When I follow "For Peer Advisors"
    And I press "Register"
    Then I should see "Peer Advisor was successfully added."

Feature: Peer advisor can sign in

  So that I can indicate my students' meeting preferences
  As a peer advisor
  I want to sign in to the app

  Background: I am registered as a peer advisor
    Given I am not signed in
    And I am registered as a "Peer Advisor"  

  Scenario: I sign in with valid credentials
    When I go to the home page
    And I follow "Peer Advisors"
    And I fill in my CalNet account information
    And I press "Authenticate"
    Then I should be on the peer advisor dashboard page

  Scenario: I sign in with invalid credentials
    When I go to the home page
    And I follow "Peer Advisors"
    And I fill in invalid CalNet account information
    And I press "Authenticate"
    Then I should see "The CalNet ID and/or Passphrase you provided are incorrect."
    And I should be unable to access the peer advisor dashboard page

  Scenario Outline: I am asked to sign in
    When I go to the <page> page
    Then I should be asked to sign in

    Scenarios:
      | page                   |
      | peer advisor dashboard |

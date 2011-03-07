Feature: All signed-in users can sign out

  So that I can secure my selections and settings from unauthorized access
  As a signed-in user
  I want to sign out of the app

  Scenario: I am registered and signed in as a faculty
    Given I am registered as a "Faculty" in "Computer Science"
    And I am signed in
    And I am on the faculty dashboard page
    When I sign out
    Then I should be unable to access the faculty dashboard page

  Scenario: I am registered and signed in as a peer advisor
    Given I am registered as a "Peer Advisor"
    And I am signed in
    And I am on the peer advisor dashboard page
    When I follow "Sign Out"
    Then I should be unable to access the peer advisor dashboard page

  Scenario: I am registered and signed in as a staff
    Given I am registered as a "Staff"
    And I am signed in
    And I am on the staff dashboard page
    When I follow "Sign Out"
    Then I should be unable to access the staff dashboard page

Feature: Visitors can rank hosts

  So that I can meet with the hosts I want
  As a visitor
  I want to rank hosts
  
  Background: I am signed in as a visitor for the event
    Given I am signed in as a "User"
    And the following people have been added:
      | ldap_id | role          | name           | email            |
      | ID1     | user          | User1          | email1@email.com |
      | ID2     | user          | User2          | email2@email.com |
      | ID3     | user          | User3          | email3@email.com |
      | ID4     | user          | User4          | email4@email.com |
    And the following event has been added:
      | name           | meeting_length | meeting_gap | max_meetings_per_visitor |
      | Visit Day 2011 | 900            | 300         | 10                       |
    And the following visitor has been added to the event:
      | name    |
      | My Name |
    And the following hosts have been added to the event:
      | name  |
      | User1 |
      | User2 |
      | User3 |
      | User4 |

  Scenario: If I have not ranked any hosts, I am asked to select hosts to rank
    Given I am on the view event page
    When I follow "Update My Rankings"
    Then I should be on the select hosts page

  Scenario: I select new hosts to rank
    Given I am on the view event page
    When I follow "Update My Rankings"
    And I check "User1"
    And I check "User3"
    And I press "Rank Hosts"
    Then I should be on the rank hosts page
    And I should see "User1"
    And I should see "User3"

  Scenario: I rank some new hosts
    Given I am on the view event page
    When I follow "Update My Rankings"
    And I check "User2"
    And I check "User4"
    And I press "Rank Hosts"
    And I rank the host named "User2" "2"
    And I rank the host named "User4" "1"
    And I press "Update Rankings"
    Then I should see "Visitor was successfully updated."

  Scenario: I give two hosts duplicate ranks
    Given I am on the view event page
    When I follow "Update My Rankings"
    And I check "User2"
    And I check "User4"
    And I press "Rank Hosts"
    And I rank the host named "User2" "2"
    And I rank the host named "User4" "2"
    And I press "Update Rankings"
    Then I should see "Ranks must be unique"
    And I should see "User2"
    And I should see "User4"

  Scenario: I give two hosts duplicate ranks twice
    Given I am on the view event page
    When I follow "Update My Rankings"
    And I check "User2"
    And I check "User4"
    And I press "Rank Hosts"
    And I rank the host named "User2" "2"
    And I rank the host named "User4" "2"
    And I press "Update Rankings"
    And I press "Update Rankings"
    Then I should see "Ranks must be unique"
    And I should see "User2"
    And I should see "User4"

  Scenario: I can view my host rankings
    Given I have the following rankings:
      | rank | name  |
      | 1    | User1 |
      | 2    | User2 |
      | 3    | User3 |
    And I am on the view event page
    When I follow "Update My Rankings"
    Then I should be on the rank hosts page
    And I should see "User1"
    And I should see "User2"
    And I should see "User3"

  Scenario: I add additional hosts rankings
    Given I have the following rankings:
      | rank | name  |
      | 1    | User1 |
    And I am on the rank hosts page
    When I follow "Add"
    And I check "User2"
    And I press "Rank Hosts"
    And I rank the host named "User2" "1"
    And I rank the host named "User1" "2"
    And I press "Update Rankings"
    Then I should see "Visitor was successfully updated."

  Scenario: I change some rankings
    Given I have the following rankings:
      | rank | name  |
      | 1    | User1 |
      | 2    | User2 |
      | 3    | User3 |
    When I go to the rank hosts page
    And I rank the host named "User2" "1"
    And I rank the host named "User1" "2"
    And I press "Update Rankings"
    Then I should see "Visitor was successfully updated"

  Scenario: I remove some rankings
    Given I have the following rankings:
      | rank | name  |
      | 1    | User1 |
      | 2    | User2 |
      | 3    | User3 |
    When I go to the rank hosts page
    And I flag the host named "User2" for removal
    And I flag the host named "User3" for removal
    And I press "Update Rankings"
    Then I should see "Visitor was successfully updated"
    And I should see "User1"
    But I should not see "User2"
    And I should not see "User3"

  Scenario: The administrators have disabled visitors from making further changes

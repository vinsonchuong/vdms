Feature: Faculty can rank admits

  So that I can meet with the admits I want
  As a faculty
  I want to rank the admits
  
  Background: I am signed in as a faculty
    Given I am registered as a "Faculty" in "Computer Science"
    And I am signed in
    And the following "Admits" have been added:
      | first_name  | last_name  | email            | phone      | area1                      | area2                | division               |
      | Aaa         | Aaa        | email1@email.com | 1234567891 | Artificial Intelligence    | Physical Electronics | Electrical Engineering |
      | Bbb         | Bbb        | email2@email.com | 1234567892 | Graphics                   | Programming Systems  | Computer Science       |
      | Ccc         | Ccc        | email3@email.com | 1234567893 | Human-Computer Interaction | Education            | Computer Science       |

  Scenario: If I have yet ranked any admits, I am asked to select admits to rank
    Given I am on the faculty dashboard page
    When I follow "Update My Admit Rankings"
    Then I should be on the select admits page

  Scenario: I select new admits to rank
    Given I am on the faculty dashboard page
    When I follow "Update My Admit Rankings"
    And I check "Aaa Aaa"
    And I check "Ccc Ccc"
    And I press "Rank Admits"
    Then I should be on the rank admits page
    And I should see "Aaa Aaa"
    And I should see "Ccc Ccc"

  Scenario: I filter and select new admits by area
    Given I am on the faculty dashboard page
    When I follow "Update My Admit Rankings"
    And I unselect every area
    And I check "Artificial Intelligence"
    And I check "Graphics"
    And I press "Filter Admits"
    Then I should see "Aaa Aaa"
    And I should see "Bbb Bbb"
    But I should not see "Ccc Ccc"

  Scenario: I rank some new admits
    Given I am on the faculty dashboard page
    When I follow "Update My Admit Rankings"
    And I unselect every area
    And I check "Artificial Intelligence"
    And I check "Graphics"
    And I press "Filter Admits"
    And I check "Aaa Aaa"
    And I check "Bbb Bbb"
    And I press "Rank Admits"
    And I rank the "first" admit "2"
    And I flag the "first" admit as "1-On-1"
    And I flag the "first" admit as "Mandatory"
    And I rank the "second" admit "1"
    And I select "2" time slots for the "second" admit
    And I press "Update Rankings"
    Then I should see "Faculty was successfully updated."

  Scenario: I give two admits duplicate ranks
    Given I am on the faculty dashboard page
    When I follow "Update My Admit Rankings"
    And I check "Aaa Aaa"
    And I check "Bbb Bbb"
    And I press "Rank Admits"
    And I rank the "first" admit "2"
    And I rank the "second" admit "2"
    And I press "Update Rankings"
    Then I should see "Ranks must be unique"
    And I should see "Aaa Aaa"
    And I should see "Bbb Bbb"

  Scenario: I give two admits duplicate ranks twice
    Given I am on the faculty dashboard page
    When I follow "Update My Admit Rankings"
    And I check "Aaa Aaa"
    And I check "Bbb Bbb"
    And I press "Rank Admits"
    And I rank the "first" admit "2"
    And I rank the "second" admit "2"
    And I press "Update Rankings"
    And I press "Update Rankings"
    Then I should see "Ranks must be unique"
    And I should see "Aaa Aaa"
    And I should see "Bbb Bbb"

  Scenario: I can view my admit rankings
    Given I have the following admit rankings:
      | rank | admit   |
      | 1    | Aaa Aaa |
      | 2    | Bbb Bbb |
      | 3    | Ccc Ccc |
    And I am on the faculty dashboard page
    When I follow "Update My Admit Rankings"
    Then I should be on the rank admits page
    And I should see "Aaa Aaa"
    And I should see "Bbb Bbb"
    And I should see "Ccc Ccc"

  Scenario: I add additional admit rankings
    Given I have the following admit rankings:
      | rank | admit   |
      | 1    | Aaa Aaa |
    And I am on the rank admits page
    When I follow "Add Admits"
    And I unselect every area
    And I check "Bbb Bbb"
    And I press "Rank Admits"
    And I rank the "first" admit "2"
    And I flag the "first" admit as "1-On-1"
    And I flag the "first" admit as "Mandatory"
    And I rank the "second" admit "1"
    And I select "2" time slots for the "second" admit
    And I press "Update Rankings"
    Then I should see "Faculty was successfully updated."

  Scenario: I change some rankings
    Given I have the following admit rankings:
      | rank | admit   |
      | 1    | Aaa Aaa |
      | 2    | Bbb Bbb |
      | 3    | Ccc Ccc |
    When I go to the rank admits page
    And I rank the "first" admit "2"
    And I rank the "second" admit "1"
    And I press "Update Rankings"
    Then I should see "Faculty was successfully updated"

  Scenario: I remove some rankings
    Given I have the following admit rankings:
      | rank | admit   |
      | 1    | Aaa Aaa |
      | 2    | Bbb Bbb |
      | 3    | Ccc Ccc |
    When I go to the rank admits page
    And I flag the "second" admit for removal
    And I flag the "third" admit for removal
    And I press "Update Rankings"
    Then I should see "Faculty was successfully updated"
    And I should see "Aaa Aaa"
    But I should not see "Bbb Bbb"
    And I should not see "Ccc Ccc"

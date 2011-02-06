@peer_advisor_can_rank_faculty_on_behalf_of_admits
Feature: Peer advisor can rank faculty on behalf of admits

  So that I can specify the meeting preferences of my admits
  As a peer advisor
  I want to rank the faculty on behalf of my admits

  Background: I am signed in as a peer advisor and my admits are registered
    Given I am registered as a "Peer Advisor"
    And I am signed in
    And the following "Admits" have been added:
      | first_name  | last_name  | email            | phone      | area1   | area2   |
      | First1      | Last1      | email1@email.com | 1234567891 | Area 11 | Area 21 |
      | First2      | Last2      | email2@email.com | 1234567892 | Area 12 | Area 22 |
      | First3      | Last3      | email3@email.com | 1234567893 | Area 13 | Area 23 |
    And the following "Faculty" have been added:
      | calnet_id | first_name  | last_name | email            | area  | division               |
      | ID1       | Faculty     | Aaaa      | email1@email.com | Area1 | Computer Science       |
      | ID2       | Faculty     | Cccc      | email2@email.com | Area2 | Electrical Engineering |
      | ID3       | Faculty     | Bbbb      | email3@email.com | Area3 | Computer Science       |

  Scenario: I specify an admit's faculty rankings
    Given I am on the view admits page
    When I follow "Update Faculty Rankings"
    And I fill in "Rank" with "1" for the new ranking
    And I select "Faculty Aaaa" from "Faculty" for the new ranking
    And I press "Save changes"
    And I fill in "Rank" with "2" for the new ranking
    And I select "Faculty Bbbb" from "Faculty" for the new ranking
    And I press "Save changes"
    And I fill in "Rank" with "3" for the new ranking
    And I select "Faculty Cccc" from "Faculty" for the new ranking
    Then I should see "Admit was successfully updated"

  Scenario: I change an admit's faculty rankings
    Given my admit has the following faculty rankings:
      | rank | faculty      |
      | 1    | Faculty Aaaa |
      | 2    | Faculty Bbbb |
      | 3    | Faculty Cccc |
    When I go to the rank faculty page
    And I fill in "Rank" with "2" for the first ranking
    And I fill in "Rank" with "1" for the second ranking
    And I press "Save changes"
    Then show me the page
    Then I should see "Admit was successfully updated"

  Scenario: I remove an admit's faculty ranking
    Given my admit has the following faculty rankings:
      | rank | faculty      |
      | 1    | Faculty Aaaa |
      | 2    | Faculty Bbbb |
      | 3    | Faculty Cccc |
    When I go to the rank faculty page
    And I check "Remove" for the second ranking
    And I check "Remove" for the third ranking
    And I press "Save changes"
    Then show me the page
    Then I should see "Admit was successfully updated"

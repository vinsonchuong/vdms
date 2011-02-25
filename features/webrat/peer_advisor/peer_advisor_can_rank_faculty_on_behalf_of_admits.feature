Feature: Peer advisor can rank faculty on behalf of admits

  So that I can specify the meeting preferences of my admits
  As a peer advisor
  I want to rank the faculty on behalf of my admits

  Background: I am signed in as a peer advisor and my admits are registered
    Given I am registered as a "Peer Advisor"
    And I am signed in
    And the following "Admits" have been added:
      | first_name  | last_name  | email            | phone      | division               | area1                      | area2                |
      | First1      | Last1      | email1@email.com | 1234567891 | Computer Science       | Artificial Intelligence    | Theory               |
      | First2      | Last2      | email2@email.com | 1234567892 | Computer Science       | Human-Computer Interaction | Graphics             |
      | First3      | Last3      | email3@email.com | 1234567893 | Electrical Engineering | Integrated Circuits        | Physical Electronics |
    And the following "Faculty" have been added:
      | first_name  | last_name | email            | division               | area                |
      | Faculty     | Aaaa      | email1@email.com | Computer Science       | Theory              |
      | Faculty     | Cccc      | email2@email.com | Electrical Engineering | Integrated Circuits |
      | Faculty     | Bbbb      | email3@email.com | Computer Science       | Graphics            |

  Scenario: I specify an admit's faculty rankings
    Given I am on the view admits page
    When I follow "Update Rankings"
    And I fill in "Rank" with "1" for the new ranking
    And I select "Faculty Aaaa" from "Faculty" for the new ranking
    And I press "Update Faculty Rankings"
    And I fill in "Rank" with "2" for the new ranking
    And I select "Faculty Bbbb" from "Faculty" for the new ranking
    And I press "Update Faculty Rankings"
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
    And I press "Update Faculty Rankings"
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
    And I press "Update Faculty Rankings"
    Then I should see "Admit was successfully updated"

Feature: Staff can view master meeting schedule

  So that I can identify possible improvements to the master schedule
  As a staff
  I want to view the master meeting schedule

  Background: I am signed in as a staff and my admits are registered
     Given I am registered as a "Staff"
     And I am signed in
     And the following "Admits" have been added:
       | id | first_name | last_name | email            |      phone | division         | area1                       | area2               |
       | 34 | Frances    | Allen     | email1@email.com | 1234567891 | Computer Science | Artificial Intelligence     | Theory              |
       | 35 | Donald     | Norman    | email2@email.com | 1234567892 | Computer Science | Human-Computer Interaction  | Graphics            |
       | 36 | Alan       | Turing    | alan@turing.com  | 1234567893 | Computer Science | Theory                      | Graphics            |
       | 37 | Jim        | Gray      | jim@gray.com     | 1234567894 | Computer Science | Database Management Systems | Programming Systems |
     And the following "Faculty" have been added:
       | id | first_name | last_name | email            | division               | area                           |
       | 56 | Jitendra   | Malik     | email1@email.com | Computer Science       | Theory                         |
       | 57 | Kris       | Pister    | email2@email.com | Electrical Engineering | Integrated Circuits            |
       | 58 | Armando    | Fox       | fox@email.com    | Computer Science       | Operating Systems & Networking |
     And the following 20-minute meetings are scheduled starting at 10:00:
       | faculty        | time_0        | time_1        | time_2        |
       | Jitendra Malik | Frances Allen | Jim Gray      | Donald Norman |
       |                | Alan Turing   |               |               |
       | Armando Fox    |               | Frances Allen | Frances Allen |
       | Kris Pister    | Jim Gray      | Alan Turing   |               |
       |                | Donald Norman |               |               |

  Scenario: follow link to master schedule
    Given I am on the staff dashboard page
    Then I should see "View Master Schedule"
    When I follow "View Master Schedule"
    Then I should be on the master meetings page

  Scenario: view master schedule
    When I go to the master meetings page
    Then I should see "Jitendra Malik"
    And  I should see "Armando Fox"
    And  I should see "Kris Pister"
    And  I should see "Frances Allen"
    And  I should see "Alan Turing"

  Scenario: follow link from master schedule to admit's schedule
    When I go to the master meetings page
    And  I follow "Jim Gray"
    Then I should be on the view admit meeting schedule page for "Jim Gray"
    And  I should see "Jitendra Malik"
    And  I should see "Kris Pister"
    But  I should not see "Armando Fox"

  Scenario: follow link from master schedule to faculty's schedule
    When I go to the master meetings page
    And  I follow "Armando Fox"
    Then I should be on the view faculty meeting schedule page for "Armando Fox"
    And  I should see "Frances Allen"
    But  I should not see "Jim Gray"


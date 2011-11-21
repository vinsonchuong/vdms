Feature: Staff can view meeting statistics

  So that I can evaluate the current meeting schedules
  As a staff
  I want to view meeting statistics

  Background: I am signed in as a staff and my admits are registered
     Given I am registered as a "Staff"
     And I am signed in
     And the following "Admits" have been added:
       | first_name | last_name | email            |      phone | division         | area1                       | area2               |
       | Frances    | Allen     | email1@email.com | 1234567891 | Computer Science | Artificial Intelligence     | Theory              |
       | Donald     | Norman    | email2@email.com | 1234567892 | Computer Science | Human-Computer Interaction  | Graphics            |
       | Alan       | Turing    | alan@turing.com  | 1234567893 | Computer Science | Theory                      | Graphics            |
       | Jim        | Gray      | jim@gray.com     | 1234567894 | Computer Science | Database Management Systems | Programming Systems |
     And the following "Faculty" have been added:
       | first_name | last_name | email            | division               | area                           |
       | Jitendra   | Malik     | email1@email.com | Computer Science       | Theory                         |
       | Kris       | Pister    | email2@email.com | Electrical Engineering | Integrated Circuits            |
       | Armando    | Fox       | fox@email.com    | Computer Science       | Operating Systems & Networking |
     Given "Jitendra Malik" has the following admit rankings:
       | rank | admit         | mandatory |
       | 1    | Frances Allen | true      |
       | 2    | Alan Turing   | true      |
     And the following 20-minute meetings are scheduled starting at 10:00:
       | faculty        | time_0        | time_1        | time_2        |
       | Jitendra Malik | Frances Allen | Jim Gray      | Donald Norman |
       | Armando Fox    |               | Frances Allen | Frances Allen |
       | Kris Pister    |               | Alan Turing   |               |
       |                | Donald Norman |               |               |

  Scenario: I view a list of unsatisfied admits
    Given the unsatisfied admit threshold is "2"
    And I am on the staff dashboard page
    When I follow "Meeting Statistics"
    Then I should see "Jim Gray"
    And I should see "Alan Turing"
    But I should not see "Frances Allen"
    And I should not see "Donald Norman"

  Scenario: I view a list of mandatory meetings not scheduled
    Given I am on the staff dashboard page
    When I follow "Meeting Statistics"
    Then I should see "Jitendra Malik"
    And I should see "Alan Turing"
    But I should not see "Kris Pister"

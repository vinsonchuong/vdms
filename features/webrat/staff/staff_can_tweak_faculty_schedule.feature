Feature: staff can manually tweak faculty's schedule

  So that I can make last-minute changes to accommodate faculty or admits
  As a staff
  I want to manually tweak a faculty member's schedule

Background: I am signed in as staff and a faculty member's schedule has been generated
  Given I am registered as a "Staff"
  And I am signed in
  And the following "Admits" have been added:
    | id | first_name | last_name | email            |      phone | division         | area1                       | area2               |
    | 34 | Frances    | Allen     | email1@email.com | 1234567891 | Computer Science | Artificial Intelligence     | Theory              |
    | 35 | Donald     | Norman    | email2@email.com | 1234567892 | Computer Science | Human-Computer Interaction  | Graphics            |
    | 36 | Alan       | Turing    | alan@turing.com  | 1234567893 | Computer Science | Theory                      | Graphics            |
    | 37 | Jim        | Gray      | jim@gray.com     | 1234567894 | Computer Science | Database Management Systems | Programming Systems |
  And the following "Faculty" have been added:
    | id | first_name | last_name | email            | division         | area   |
    | 56 | Jitendra   | Malik     | email1@email.com | Computer Science | Theory |
  And the following 20-minute meetings are scheduled starting at 10:00:
    | faculty        | time_0        | time_1   | time_2 | time_3        |
    | Jitendra Malik | Frances Allen | Jim Gray |        | Donald Norman |
    |                | Alan Turing   |          |        |               |
  And the "max admits per meeting" for Faculty "Jitendra Malik" is 3
  And I am on the tweak faculty schedule page for "Jitendra Malik"
  Then show me the page

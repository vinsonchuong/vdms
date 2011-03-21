Feature: Peer advisor can view meeting schedules for admits

  So that I can inform my admits of their assigned meetings
  As a peer advisor
  I want to view my admits' meeting schedules
  
  Background: I am signed in as a peer advisor and my admits are registered
    Given I am registered as a "Peer Advisor"
    And I am signed in
    And the following "Admits" have been added:
      | id | first_name  | last_name  | email            | phone      | division               | area1                      | area2    |
      | 34 | First1      | Last1      | email1@email.com | 1234567891 | Computer Science       | Artificial Intelligence    | Theory   |
      | 35 | First2      | Last2      | email2@email.com | 1234567892 | Computer Science       | Human-Computer Interaction | Graphics |
    And the following "Faculty" have been added:
      | id  | first_name  | last_name | email            | division               | area                |
      | 36  | test1        | foo      | email1@email.com | Computer Science       | Theory              |
      | 37  | test2        | bar      | email2@email.com | Electrical Engineering | Integrated Circuits |
  
      
  Scenario: I view the meeting schedules of all my admits given schedules have been generated

  Scenario: I view the meeting schedules of all my admits given no schedules have been generated

  Scenario: I view the meeting schedule of one of my admits given a schedule has been generated

  Scenario: I view the meeting schedule of one of my admits given no schedule has been generated

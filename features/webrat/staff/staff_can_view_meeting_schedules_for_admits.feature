Feature: Staff can view meeting schedules for admits

  So that I can inform my admits of their assigned meetings
  As a staff
  I want to view my admits' meeting schedules
  
  Background: I am signed in as a staff and my admits are registered
     Given I am registered as a "Staff"
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
     Given I am on the view admits page
     And my first admit has the following meeting schedule:
       | time  | room | faculty_id |
       | 12:00 | soda | 36         |
       | 13:00 | cory | 37         |
     When I follow "View Meeting Schedule" for the first admit
     Then I should see "Time"
     And I should see "Faculty Name"
     And I should see "Room"
     And I should see "test1"
     And I should see "test2"
     And I should see "foo"
     And I should see "bar"
     And I should see "soda"
     And I should see "cory"
     And I should see "12:00"
     And I should see "13:00"
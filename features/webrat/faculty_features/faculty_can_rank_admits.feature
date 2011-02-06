@faculty_can_rank_admits
Feature: Faculty can rank admits

  So that I can meet with the admits I want
  As a faculty
  I want to rank the admits
  
  Background: I am signed in as a faculty
    Given "Jacky" "Wu" is registered as a "Faculty" in "Computer Science"
    And I am signed in
    And the following "Admits" have been added:
      | first_name  | last_name  | email            | phone      | area1                      | area2                |
      | Andy        | Foo        | email1@email.com | 1234567891 | Artificial Intelligence    | Physical Electronics |
      | Ben         | Bar        | email2@email.com | 1234567892 | Graphics                   | Programming Systems  |
      | Charlie     | Goo        | email3@email.com | 1234567893 | Human-Computer Interaction | Education            |
  
  
  Scenario: I can see a list of different areas of interests in the EECS department
    Given I am on the faculty dashboard page
    When I follow "My Desired Appointments"
    And I follow "Update My Desired Appointments"
    Then I should see "Artificial Intelligence"
    And I should see "Biosystems & Computational Biology"
    And I should see "Communications & Networking"
    And I should see "Computer Architecture & Engineering"
    And I should see "Control, Intelligent Systems, and Robotics"
    And I should see "Database Management Systems"
    And I should see "Design of Electronic Systems"
    And I should see "Education"
    And I should see "Energy"
    And I should see "Graphics"
    And I should see "Human-Computer Interaction"
    And I should see "Integrated Circuits"
    And I should see "Micro/Nano Electro Mechanical Systems"
    And I should see "Operating Systems & Networking"
    And I should see "Physical Electronics"
    And I should see "Programming Systems"
    And I should see "Scientific Computing"
    And I should see "Security"
    And I should see "Signal Processing"
    And I should see "Theory"
      
  Scenario: I select nothing on the area of interests page
    Given I am on the area of interests page
    When I press "find"
    Then I should see "Name"
  
  Scenario: I filter the admits by the area of interests
    Given I am on the area of interests page
    When I check "Artificial Intelligence"
    And I check "Graphics"
    And I check "Physical Electronics"
    Then I should see "Andy Foo"
    Then I should see "Ben Bar"
    
  Scenario: I rank a subset of the admits

  Scenario: I flag an admit for a one-on-one meeting

  Scenario: I flag an admit for a mandatory meeting

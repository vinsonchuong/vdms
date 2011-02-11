@faculty_can_rank_admits
Feature: Faculty can rank admits

  So that I can meet with the admits I want
  As a faculty
  I want to rank the admits
  
  Background: I am signed in as a faculty
    Given "Jacky" "Wu" is registered as a "Faculty" in "Computer Science"
    And I am signed in
    And the following "Admits" have been added:
      | first_name  | last_name  | email            | phone      | area1                      | area2                | division              |
      | Andy        | Foo        | email1@email.com | 1234567891 | Artificial Intelligence    | Physical Electronics | Electrical Engineering|
      | Ben         | Bar        | email2@email.com | 1234567892 | Graphics                   | Programming Systems  | Computer Science      |
      | Charlie     | Goo        | email3@email.com | 1234567893 | Human-Computer Interaction | Education            | Computer Science      |

  Scenario: I can add admits to my desired appointments
    Given I am on the faculty dashboard page
    When I follow "My Desired Appointments"
    And I follow "Add Admits to My Desired Appointments"
    Then I should be on the Add Admits to My Desired Appointments page

  Scenario: I can see a list of different areas of interests in the EECS department
    Given I am on the Add Admits to My Desired Appointments page
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
  
  Scenario: I can see a list of EECS divisions
    Given I am on the Add Admits to My Desired Appointments page
    Then I should see "Computer Science"
    Then I should see "Electrical Engineering"

  Scenario: I can see a list of admits section
    Given I am on the Add Admits to My Desired Appointments page
    Then I should see "List of Admits"
    Then I should see "Select Admits"
            
  Scenario: I select nothing on the area of interests page
    Given I am on the Add Admits to My Desired Appointments page
    When I press "Filter Admits"
    Then I should see "List of Admits"
    Then I should see "Select Admits"
  
  Scenario: I filter the admits by their area of interests
    Given I am on the Add Admits to My Desired Appointments page
    When I check "filter[areas][Artificial Intelligence]"
    And I check "filter[areas][Graphics]"
    And I check "filter[areas][Physical Electronics]"
    When I press "Filter Admits"
    Then I should see "Andy Foo"
    Then I should see "Ben Bar"
  
  Scenario: I filter the admits by their divisions
    Given I am on the Add Admits to My Desired Appointments page
    When I check "filter[divisions][Computer Science]"
    When I press "Filter Admits"
    Then I should see "Ben Bar"
    Then I should see "Charlie Goo"
  
  Scenario: I can add admits to my desired appointment
    Given I am on the Add Admits to My Desired Appointments page
    When I check "filter[divisions][Computer Science]"
    And I press "Filter Admits"
    And I check "admits_3" #Ben Bar
    And I press "Add to My Desired Appointment List"
    
  Scenario: I rank a subset of the admits

  Scenario: I flag an admit for a one-on-one meeting

  Scenario: I flag an admit for a mandatory meeting

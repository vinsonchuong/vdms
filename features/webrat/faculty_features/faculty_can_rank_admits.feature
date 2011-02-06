Feature: Faculty can rank admits

  So that I can meet with the admits I want
  As a faculty
  I want to rank the admits
  
  Background: I am signed in as a faculty
    Given I am registered as a "Faculty" in "Computer Science"
    And I am signed in
  
  Scenario: I can see a list of different areas of interests in the EECS department
    Given I am on the faculty dashboard page
    When I follow "My Desired Appointments"
    And I follow
  
  
  Scenario: I filter the admits by research area
  
  Scenario: I rank a subset of the admits

  Scenario: I flag an admit for a one-on-one meeting

  Scenario: I flag an admit for a mandatory meeting

Feature: Faculty can view meeting schedule

  So that I know the details of my meetings
  As a faculty
  I want to view my meeting schedule

  Background: I am signed in as faculty
    Given "Jitendra" "Malik" is registered as a "Faculty" in "Computer Science"
    And Jitendra Malik is signed in
    And I am on the faculty dashboard page

  Scenario: I view my meeting schedule given a schedule has been generated

  Scenario: I view my meeting schedule given no schedule has been generated
    When I follow "View My Schedule"
    Then I should be on the view faculty meeting schedule page for "Jitendra Malik"
    And I should see "The master schedule has not been generated yet."

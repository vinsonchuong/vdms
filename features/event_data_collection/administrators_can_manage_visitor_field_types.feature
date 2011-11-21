Feature: Administrators can manage visitor field types

  To ensure that I am collecting the right information from the visitor
  As an administrator
  I want to manage visitor field types

  Background: I am signed in as an administrator
    Given the following event has been added:
      | name            |
      | Visit Day 2011  |
    And the following visitor field types have been added to the event:
      | name         | description                | data_type |
      | Text Field 1 | This is a text field       | text      |
      | Text Field 2 | This is another text field | text      |
    And I am signed in as an "Administrator"

  Scenario: I view a list of visitor field types
    Given I am on the view event page
    When I follow "Manage Visitor Fields"
    Then I should be on the view visitor fields page
    And I should see "Text Field 1"
    And I should see "Text Field 2"

  Scenario: I add a text field
    Given I am on the view visitor fields page
    When I follow "Add Visitor Field"
    And I select "Text" from "Data Type"
    And I press "Add Visitor Field"
    And I fill in "Name" with "Text Field"
    And I fill in "Description" with "This is a text field"
    And I press "Add Visitor Field"
    Then I should see "Visitor field was successfully added"

  Scenario: I update a visitor field type
    Given I want to manage the visitor field type named "Text Field 1"
    And I am on the view visitor fields page
    When I follow "Edit Visitor Field" for the visitor field type named "Text Field 1"
    And I fill in "Name" with "New Name"
    And I fill in "Description" with "New Description"
    And I press "Update Visitor Field"
    Then I should see "Visitor field was successfully updated"
    And I should see "New Name"

  Scenario: I remove a visitor field type
    Given I want to manage the visitor field type named "Text Field 1"
    And I am on the view visitor fields page
    When I follow "Remove Visitor Field" for the visitor field type named "Text Field 1"
    And I press "Remove Visitor Field"
    Then I should see "Visitor field was successfully removed"
    And I should not see "Text Field 1"


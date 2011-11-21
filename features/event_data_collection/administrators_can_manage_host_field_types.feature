Feature: Administrators can manage host field types

  To ensure that I am collecting the right information from the hosts
  As an administrator
  I want to manage host field types

  Background: I am signed in as an administrator
    Given the following event has been added:
      | name            |
      | Visit Day 2011  |
    And the following host field types have been added to the event:
      | name         | description                | data_type |
      | Text Field 1 | This is a text field       | text      |
      | Text Field 2 | This is another text field | text      |
    And I am signed in as an "Administrator"

  Scenario: I view a list of host field types
    Given I am on the view event page
    When I follow "Manage Host Fields"
    Then I should be on the view host fields page
    And I should see "Text Field 1"
    And I should see "Text Field 2"

  Scenario: I add a text field
    Given I am on the view host fields page
    When I follow "Add Host Field"
    And I select "Text" from "Data Type"
    And I press "Add Host Field"
    And I fill in "Name" with "Text Field"
    And I fill in "Description" with "This is a text field"
    And I press "Add Host Field"
    Then I should see "Host field was successfully added"

  Scenario: I update a host field type
    Given I want to manage the host field type named "Text Field 1"
    And I am on the view host fields page
    When I follow "Edit Host Field" for the host field type named "Text Field 1"
    And I fill in "Name" with "New Name"
    And I fill in "Description" with "New Description"
    And I press "Update Host Field"
    Then I should see "Host field was successfully updated"
    And I should see "New Name"

  Scenario: I remove a host field type
    Given I want to manage the host field type named "Text Field 1"
    And I am on the view host fields page
    When I follow "Remove Host Field" for the host field type named "Text Field 1"
    And I press "Remove Host Field"
    Then I should see "Host field was successfully removed"
    And I should not see "Text Field 1"


Feature: Staff can manage admits

  So that peer advisors can specify the meeting preferences of their admits and faculty can specify theirs
  As a staff
  I want to add admits to the app

  Background: I am signed in as a staff
    Given the following "Admits" have been added:
      | first_name  | last_name  | email            | phone      | area1                       | area2    |
      | First1      | Last1      | email1@email.com | 1234567891 | Theory                      | Graphics |
      | First2      | Last2      | email2@email.com | 1234567892 | Communications & Networking | Energy   |
      | First3      | Last3      | email3@email.com | 1234567893 | Human-Computer Interaction  | Graphics |
    Given the event has the following meeting time slots:
      | begin            | end              |
      | 1/1/2011 09:00AM | 1/1/2011 09:15AM |
      | 1/1/2011 09:15AM | 1/1/2011 09:30AM |
      | 1/1/2011 09:30AM | 1/1/2011 09:45AM |
      | 1/1/2011 09:45AM | 1/1/2011 10:00AM |
      | 1/1/2011 10:00AM | 1/1/2011 10:15AM |
      | 1/1/2011 10:15AM | 1/1/2011 10:30AM |
      | 1/1/2011 10:30AM | 1/1/2011 10:45AM |
      | 1/1/2011 10:45AM | 1/1/2011 11:00AM |
      | 1/1/2011 02:00PM | 1/1/2011 02:15PM |
      | 1/1/2011 02:15PM | 1/1/2011 02:30PM |
      | 1/1/2011 02:30PM | 1/1/2011 02:45PM |
    And I am registered as a "Staff"
    And I am signed in

  Scenario: I can manage admits
    Given I am on the staff dashboard page
    When I follow "Manage Admits"
    Then I should be on the view admits page

  Scenario: I view a list of all admits
    When I go to the view admits page
    And I should see "First1"
    And I should see "Last1"
    And I should see "email1@email.com"
    And I should see "1234567891"
    And I should see "First2"
    And I should see "Last2"
    And I should see "email2@email.com"
    And I should see "1234567892"
    And I should see "First3"
    And I should see "Last3"
    And I should see "email3@email.com"
    And I should see "1234567893"

  Scenario Outline: I add an admit
    Given I am on the view admits page
    When I follow "Add Admit"
    And I fill in "First Name" with "<first_name>"
    And I fill in "Last Name" with "<last_name>"
    And I fill in "Email" with "<email>"
    And I fill in "Phone" with "<phone>"
    And I select "<area1>" from "Area 1"
    And I select "<area2>" from "Area 2"
    And I press "Add Admit"
    And I should see "<result>" 

    Scenarios: with valid information
      | first_name | last_name | email           | phone          | area1                       | area2             | result                        |
      | First      | Last      | email@email.com | 123-456-7890   | Artificial Intelligence     | Theory            | Admit was successfully added. |
      | First      | Last      | email@email.com | 123.456.7890   | Human-Computer Interaction  | Graphics          | Admit was successfully added. |
      | First      | Last      | email@email.com | (123) 456-7890 | Communications & Networking | Energy            | Admit was successfully added. |
      | First      | Last      | email@email.com | 1234567890     | Physical Electronics        | Signal Processing | Admit was successfully added. |

    Scenarios: with invalid information
      | first_name | last_name | email           | phone          | area1                       | area2             | result                              |
      |            | Last      | email@email.com | 123-456-7890   | Artificial Intelligence     | Theory            | First Name can't be blank           |
      | First      |           | email@email.com | 123-456-7890   | Artificial Intelligence     | Theory            | Last Name can't be blank            |

  Scenario: I add admits by importing a CSV with valid data
    Given I am on the view admits page
    When I follow "Import Admits"
    And I attach the file "features/assets/valid_admits.csv" to "CSV File"
    And I press "Import"
    Then I should see "Admits were successfully imported."
    And I should see "First1"
    And I should see "First2"
    And I should see "First3"

  Scenario: I try to add admits by importing a CSV with some invalid data
    Given I am on the view admits page
    When I follow "Import Admits"
    And I attach the file "features/assets/invalid_admits.csv" to "CSV File"
    And I press "Import"
    And I should see "Area 1 is not included in the list"

  Scenario: I see the admit's name while updating his information
    Given I am on the view admits page
    When I follow "Update Info"
    Then I should see "First1 Last1"

  Scenario: I update an admit's information
    Given I am on the view admits page
    When I follow "Update Info"
    And I fill in "Email" with "new_email@email.com"
    And I press "Update Admit"
    Then I should see "Admit was successfully updated."

  Scenario: I try to update an admit with invalid information
    Given I am on the view admits page
    When I follow "Update Info"
    And I fill in "First Name" with ""
    And I press "Update Admit"
    Then I should see "First Name can't be blank"

  Scenario: I try to update an admit with invalid information twice
    Given I am on the view admits page
    When I follow "Update Info"
    And I fill in "First Name" with ""
    And I press "Update Admit"
    And I press "Update Admit"
    Then I should see "First Name can't be blank"

  Scenario: I see the admit's name while updating his availability
    Given I am on the view admits page
    When I follow "Update Availability"
    Then I should see "First1 Last1"

  Scenario: I update an admit's availability
    Given I am on the view admits page
    When I follow "Update Availability"
    And I flag the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" slot as available
    And I flag the "1/1/2011 10:00AM" to "1/1/2011 10:15AM" slot as available
    And I press "Update Availability"
    Then I should see "Visitor was successfully updated"
    And I should be on the update admit availability page

  Scenario: I see the admit's name while updating his faculty rankings
    Given the following "Faculty" have been added:
      | ldap_id | first_name  | last_name  | email            | division               | area                       |
      | ID1     | Aaa         | Aaa        | email1@email.com | Electrical Engineering | Artificial Intelligence    |
      | ID2     | Bbb         | Bbb        | email2@email.com | Computer Science       | Graphics                   |
      | ID3     | Ccc         | Ccc        | email3@email.com | Computer Science       | Human-Computer Interaction |
    And my admit has the following faculty rankings:
      | rank | faculty |
      | 1    | Aaa Aaa |
    And I am on the view admits page
    When I follow "Update Rankings"
    Then I should see "First1 Last1"

  Scenario: I update an admit's faculty rankings
    Given the following "Faculty" have been added:
      | ldap_id | first_name  | last_name  | email            | division               | area                       |
      | ID1     | Aaa         | Aaa        | email1@email.com | Electrical Engineering | Artificial Intelligence    |
      | ID2     | Bbb         | Bbb        | email2@email.com | Computer Science       | Graphics                   |
      | ID3     | Ccc         | Ccc        | email3@email.com | Computer Science       | Human-Computer Interaction |
    And I am on the view admits page
    When I follow "Update Rankings"
    And I check "Aaa Aaa"
    And I check "Bbb Bbb"
    And I press "Rank Hosts"
    And I rank the "first" faculty "2"
    And I rank the "second" faculty "1"
    And I press "Update Rankings"
    Then I should see "Visitor was successfully updated."

  Scenario: I see the admit's name while removing him
    Given I am on the view admits page
    When I follow "Remove"
    Then I should see "First1 Last1"

  Scenario: I remove an admit
    Given I am on the view admits page
    When I follow "Remove"
    And I press "Remove Admit"
    Then I should see "Admit was successfully removed."

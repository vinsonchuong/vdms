Feature: Staff can manage faculty

  So that faculty can specify their meeting preferences and admits can specify theirs
  As a staff
  I want to add faculty to the app

  Background: I am signed in as a staff
    Given the following "Faculty" have been added:
      | ldap_id | first_name  | last_name  | email            | area     | division               |
      | ID1     | First1      | Last1      | email1@email.com | Theory   | Computer Science       |
      | ID2     | First2      | Last2      | email2@email.com | Energy   | Electrical Engineering |
      | ID3     | First3      | Last3      | email3@email.com | Graphics | Computer Science       |
    And "Computer Science" has the following meeting times:
      | begin           | end              |
      | 1/1/2011 9:00AM | 1/1/2011 11:00AM |
      | 1/1/2011 2:00PM | 1/1/2011 02:45PM |
    Given "Electrical Engineering" has the following meeting times:
      | begin           | end              |
      | 1/1/2011 9:00AM | 1/1/2011 11:00AM |
      | 1/1/2011 2:00PM | 1/1/2011 02:45PM |
    And I am registered as a "Staff"
    And I am signed in

  Scenario: I can manage faculty
    Given I am on the staff dashboard page
    When I follow "Manage Faculty"
    Then I should be on the view faculty page

  Scenario: I view a list of all faculty
    When I go to the view faculty page
    And I should see "First1"
    And I should see "Last1"
    And I should see "email1@email.com"
    And I should see "First2"
    And I should see "Last2"
    And I should see "email2@email.com"
    And I should see "First3"
    And I should see "Last3"
    And I should see "email3@email.com"

  Scenario Outline: I add a faculty
    Given I am on the view faculty page
    When I follow "Add Faculty"
    And I fill in "CalNet UID" with "<ldap_id>"
    And I fill in "First Name" with "<first_name>"
    And I fill in "Last Name" with "<last_name>"
    And I fill in "Email" with "<email>"
    And I select "<division>" from "Division"
    And I select "<area>" from "Area"
    And I press "Add Faculty"
    And I should see "<result>" 

    Scenarios: with valid information
      | ldap_id | first_name | last_name | email           | division               | area                        | result                          |
      | ID1     | First      | Last      | email@email.com | Computer Science       | Artificial Intelligence     | Faculty was successfully added. |
      | ID2     | First      | Last      | email@email.com | Electrical Engineering | Communications & Networking | Faculty was successfully added. |

    Scenarios: with invalid information
      | ldap_id | first_name | last_name | email           | division               | area                    | result                              |
      | ID1     |            | Last      | email@email.com | Computer Science       | Artificial Intelligence | First Name can't be blank           |
      | ID1     | First      |           | email@email.com | Computer Science       | Artificial Intelligence | Last Name can't be blank            |
      | ID1     | First      | Last      | invalid_email   | Computer Science       | Artificial Intelligence | Email is invalid                    |

  Scenario: I add faculty by importing a CSV with valid data
    Given I am on the view faculty page
    When I follow "Import Faculty"
    And I attach the file "features/assets/valid_faculty.csv" to "CSV File"
    And I press "Import"
    Then I should see "Faculty were successfully imported."
    And I should see "First1"
    And I should see "First2"
    And I should see "First3"

  Scenario: I try to add faculty by importing a CSV with some invalid data
    Given I am on the view faculty page
    When I follow "Import Faculty"
    And I attach the file "features/assets/invalid_faculty.csv" to "CSV File"
    And I press "Import"
    Then I should see "Email can't be blank"
    And I should see "Area is not included in the list"
    And I should see "Division is not included in the list"

  Scenario: I update a faculty's information
    Given I am on the view faculty page
    When I follow "Update Info"
    And I fill in "Email" with "new_email@email.com"
    And I press "Update Faculty"
    Then I should see "Faculty was successfully updated."

  Scenario: I try to update a faculty with invalid information
    Given I am on the view faculty page
    When I follow "Update Info"
    And I fill in "First Name" with ""
    And I press "Update Faculty"
    Then I should see "First Name can't be blank"

  Scenario: I try to update a faculty with invalid information twice
    Given I am on the view faculty page
    When I follow "Update Info"
    And I fill in "First Name" with ""
    And I press "Update Faculty"
    And I press "Update Faculty"
    Then I should see "First Name can't be blank"

  Scenario: I update a faculty's availability
    Given I am on the view faculty page
    When I follow "Update Availability"
    And I fill in "Default room" with "373 Soda"
    And I fill in "Max admits per meeting" with "4"
    And I flag the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" slot as available
    And I flag the "1/1/2011 10:00AM" to "1/1/2011 10:15AM" slot as available
    And I press "Update Availability"
    Then I should see "Faculty was successfully updated"
    And I should be on the update faculty availability page

  Scenario: I update a faculty's admit rankings
    Given the following "Admits" have been added:
      | first_name  | last_name  | email            | phone      | area1                      | area2                |
      | Aaa         | Aaa        | email1@email.com | 1234567891 | Artificial Intelligence    | Physical Electronics |
      | Bbb         | Bbb        | email2@email.com | 1234567892 | Graphics                   | Programming Systems  |
      | Ccc         | Ccc        | email3@email.com | 1234567893 | Human-Computer Interaction | Education            |
    And I am on the view faculty page
    When I follow "Update Rankings"
    And I follow "Add Admits to Rankings"
    And I check "Aaa Aaa"
    And I check "Bbb Bbb"
    And I press "Rank Admits"
    And I rank the "first" admit "2"
    And I rank the "second" admit "1"
    And I press "Update Rankings"
    Then I should see "Faculty was successfully updated."

  Scenario: I remove a faculty
    Given I am on the view faculty page
    When I follow "Remove"
    And I press "Remove Faculty"
    Then I should see "Faculty was successfully removed."

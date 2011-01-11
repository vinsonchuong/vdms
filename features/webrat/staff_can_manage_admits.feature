Feature: Staff can manage admits

  So that peer advisors can specify the meeting preferences of their admits and faculty can specify theirs
  As a staff
  I want to add admits to the app

  Scenario Outline: I add an admit

    Scenarios: with enough valid information
      | calnet_id | first_name | last_name | email | result |

    Scenarios: with insufficient or invalid information
      | calnet_id | first_name | last_name | email | result |

  Scenario Outline: I add admits via CSV import

    Scenarios: with enough valid information in each row

    Scenarios: with insufficient or invalid information in some rows

  Scenario: I view a list of admits

  Scenario: I update an admit's information

  Scenario: I update an admit's meeting availability

  Scenario: I update an admit's faculty rankings

  Scenario: I remove an admit

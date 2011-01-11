Feature: Staff can manage staff

  So that other staff can manage scheduling for visit day
  As a staff
  I want to add other staff to the app

  Scenario Outline: I add a staff

    Scenarios: with enough valid information
      | calnet_id | first_name | last_name | email | result |

    Scenarios: with insufficient or invalid information
      | calnet_id | first_name | last_name | email | result |

  Scenario Outline: I add staff via CSV import

    Scenarios: with enough valid information in each row

    Scenarios: with insufficient or invalid information in some rows

  Scenario: I view a list of staff

  Scenario: I update a staff's information

  Scenario: I remove a staff

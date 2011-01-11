Feature: Staff can manage peer advisors

  So that peer advisors can manage meeting scheduling on behalf of their admits
  As a staff
  I want to add peer advisors to the app

  Scenario Outline: I add a peer advisor 

    Scenarios: with enough valid information
      | calnet_id | first_name | last_name | email | result |

    Scenarios: with insufficient or invalid information
      | calnet_id | first_name | last_name | email | result |

  Scenario Outline: I add peer advisors via CSV import

    Scenarios: with enough valid information in each row

    Scenarios: with insufficient or invalid information in some rows

  Scenario: I view a list of peer advisors

  Scenario: I update a peer advisor's information

  Scenario: I remove a peer advisor

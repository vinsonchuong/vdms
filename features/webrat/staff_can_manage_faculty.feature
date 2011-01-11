Feature: Staff can manage faculty

  So that faculty can specify their meeting preferences and admits can specify theirs
  As a staff
  I want to add faculty to the app

  Scenario Outline: I add a faculty

    Scenarios: with enough valid information
      | calnet_id | first_name | last_name | email | area | division | default_room | max_admits_per_meeting | max_additional_admits | result |

    Scenarios: with insufficient or invalid information
      | calnet_id | first_name | last_name | email | area | division | default_room | max_admits_per_meeting | max_additional_admits | result |

  Scenario Outline: I add faculty via CSV import

    Scenarios: with enough valid information in each row

    Scenarios: with insufficient or invalid information in some rows

  Scenario: I view a list of faculty

  Scenario: I update a faculty's information

  Scenario: I update a faculty's schedule

  Scenario: I update a faculty's admit rankings and preferences

  Scenario: I remove a faculty

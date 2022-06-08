Feature: List student's curricular units
  Background:
    Given I'm logged in the uni app

  Scenario: Access the curricular units page with an Internet connection available
    Given Internet connection is available
    When I open the drawer
    And I tap the label that contains the text "Moodle"
    And I wait until the "ucs_page_view_loading" is absent
    Then I expect the text "Engenharia de Software" to be present

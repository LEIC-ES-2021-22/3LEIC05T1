Feature: Access a curricular unit's Moodle sections
  Background:
    Given I open the drawer
    And I tap the label that contains the text "Moodle"
    And I wait until the "ucs_page_view_loading" is absent

  Scenario: Access the curricular unit's Moodle sections, without an Internet connection available and cached Moodle sections
    Given Internet connection is unavailable
    When I tap the widget that contains the text "Computação Paralela e Distribuída"
    Then I expect the text "Parallel Computing" to be present

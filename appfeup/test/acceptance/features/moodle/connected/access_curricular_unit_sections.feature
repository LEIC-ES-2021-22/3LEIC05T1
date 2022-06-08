Feature: Access a curricular unit's Moodle sections
  Background:
    Given I open the drawer
    And I tap the label that contains the text "Moodle"
    And I wait until the "ucs_page_view_loading" is absent

  Scenario: Access the curricular unit's Moodle sections, with an Internet connection available
    Given Internet connection is available
    When I tap the widget that contains the text "Computação Paralela e Distribuída"
    Then I expect the text "Parallel Computing" to be present

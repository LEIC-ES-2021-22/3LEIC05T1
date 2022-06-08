Feature: Access a curricular unit's Moodle sections
  Background:
    Given that I'm in the curricular units list

  Scenario: Access the curricular unit's Moodle sections, with an Internet connection available
    Given that an Internet connection is available
    When I select the desired curricular unit
    Then the app should load the various sections in the curricular units Moodle page from the Internet and cache them for later use
    And  I should be able to see the sections displayed

  Scenario: Access the curricular unit's Moodle sections, without an Internet connection available and cached Moodle sections
    Given that no Internet connection is available
    And the to be selected curricular unit's Moodle sections are cached locally
    When I select the desired curricular unit
    Then the app should load the various sections in the curricular units Moodle page from local cache
    And  I should be able to see the sections displayed

  Scenario: Try to access the curricular unit's Moodle sections, without an Internet connection available and without cached Moodle sections
    Given that no Internet connection is available
    And the to be selected curricular unit's Moodle sections aren't available locally
    When I select the desired curricular unit
    Then an error message should be displayed to inform me
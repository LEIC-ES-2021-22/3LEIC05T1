Feature: Access a curricular unit's Moodle forum topics
  Background:
    Given that I'm in a curricular unit's sections page
    And that the forum is available for the curricular unit selected

  Scenario: Access the a curricular unit forum topics, with an Internet connection available
    Given that Internet connection is available
    When I tap/select the activity corresponding to the forum
    Then the app should load from the Internet a list with the topics currently active, and cache it for later use
    And I should see them displayed

  Scenario: Access the a curricular unit forum topics, without an Internet connection available, cached topics list
    Given that no Internet connection is available
    And the forum topics list is available locally
    When I tap/select the activity corresponding to the forum
    Then the app should load the topics list from local storage
    And I should see it displayed

  Scenario: Access the a curricular unit forum topics, without an Internet connection available, without cached topics list
    Given that no Internet connection is available
    And the forum topics list aren't available locally
    When I tap/select the activity corresponding to the forum
    Then the app should display an error message informing me that currently I can't access the forum

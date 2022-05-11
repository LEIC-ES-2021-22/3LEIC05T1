Feature: List student's curricular units
  Background:
    Given that I'm logged in the uni app
    And the side navigation menu is available

  Scenario: Access the curricular units page with an Internet connection available
    Given that an Internet connection is available
    When I select the curricular units option
    Then the app should load the list of curricular units I'm enrolled in from the Internet and cache it for later use
    And I should see it displayed

  Scenario: Access the curricular units page without an Internet connection, with cached list of curricular units
    Given that no Internet connection is available
    And the list of curricular units is locally cached
    When I select the curricular units option
    Then the app should load the list of curricular units I'm currently enrolled in from local cache
    And I should see it displayed

  Scenario: Try to access the curricular units page without an Internet connection, without cached list of curricular units
    Given that no Internet connection is available
    And that the list of curricular units isn't locally cached
    When I select the curricular units option
    Then an error should be displayed informing me
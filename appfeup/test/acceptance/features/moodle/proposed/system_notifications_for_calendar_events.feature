Feature: System notification for Moodle calendar events
  Background:
    Given that I'm in a curricular unit's sections page
    And that notifications are active for all the curricular units by default

  Scenario: Disable notifications for a curricular unit
    When I tap/select the bell icon on the top left corner
    Then notifications will no longer be generated for the curricular unit's events marked in the Moodle calendar

  Scenario: Enable notifications for a curricular unit
    Given that the curricular unit's notifications gave been previously disabled
    When I tap/select the bell icon on the top left corner
    Then notifications will be generated for the curricular unit's events marked in the Moodle calendar

  Scenario: Receive notification
    Given that my device's system accepts application generated notifications
    When a event in any of my curricular units is coming up
    Then a notification should be generated through the system notifications system
    And I can see it, reminding me of the event

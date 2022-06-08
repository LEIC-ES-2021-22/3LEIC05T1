Feature: Visualize contents referenced in Moodle's sections
  Background:
    Given that I'm in a curricular unit's sections page

  Scenario: Access an external link referenced in a section, with a default browser set on the phone
    Given that there is an external link in a section of this curricular unit
    And my device has a default browser set
    When I tap a link / icon in a section to an external web page
    Then I should seamlessly see the web page loaded by the phone's default browser app, if an internet connection can be established

  Scenario: Access an external link referenced in a section, with no default browser set on the phone
    Given that there is an external link in a section of this curricular unit
    And I don't have a default browser set in my device
    When I tap a link / icon in a section to an external web page
    Then I should should be asked by the phone's OS which app to use to follow the link
    When I select my desired app
    Then I should see the web page loaded by the phone's default browser app, if an internet connection can be established

  Scenario: Visualize an embedded Moodle HTML document, default web browser set on device
    Given that there is a embedded Moodle HTML document in a section of this curricular unit
    And that there is a default browser app set in my device
    When I tap the link / icon of that document
    Then the app should open the default web browser and redirect me to that page,
    And I should can see its contents, if an internet conection is available

  Scenario: Visualize an embedded Moodle HTML document, without a default browser set on the device
    Given that there is a embedded Moodle HTML document in a section of this curricular unit
    And that there is no default browser in my device
    When I tap the link / icon of that document
    Then I should should be asked by the phone's OS which app to use to redirect to the Moodle page
    When I select my desired app
    And I should can see its contents, if an internet conection is available

  Scenario: Try to visualize an embedded Moodle HTML document, without an internet connection established and without the cached document
    Given that there is a embedded Moodle HTML document in a section of this curricular unit
    And that there is no internet connection available
    And that the to be selected document is not available locally
    When I tap the link / icon of that document
    Then I should see an error message informing me about the file being unavailable

  Scenario: Download and visualize a file, with an Internet connection established, default application to open file is set
    Given that there is a file in a section of this curricular unit
    And that there is an internet connection available
    And the default application to open this file is defined in my device
    When I tap the link / icon to the file
    Then the app should download and save the file
    And I should be able to see it in an external app

  Scenario: Download and visualize a file, with an Internet connection established, default application to open file is set
    Given that there is a file in a section of this curricular unit
    And that there is an internet connection available
    And the default application to open this file isn't defined in my device
    When I tap the link / icon to the file
    Then the app should download and save the file
    And I should should be asked by the phone's OS which app to use to open the file
    When I select the external app to use
    And I should be able to see it in an external app

  Scenario: Visualize a file, without an Internet connection established, downloaded file, default application to open file is set
    Given that there is a file in a section of this curricular unit
    And that there is no internet connection available
    And the default application to open this file is defined in my device
    And the file is available locally
    When I tap the link / icon to the file
    Then the app should load the file from local storage
    And I should be able to see it in an external app

  Scenario: Visualize a file, without an Internet connection established, downloaded file, no default application to open file is set
    Given that there is a file in a section of this curricular unit
    And that there is no internet connection available
    And the default application to open this file isn't defined in my device
    And the file is available locally
    When I tap the link / icon to the file
    Then the app should load the file from local storage
    And I should should be asked by the phone's OS which app to use to open the file
    When I select the external app to use
    Then I should be able to see the file in the external app

  Scenario: Try to visualize a file, without an Internet connection established, file unavailable locally
    Given that there is a file in a section of this curricular unit
    And that there is no internet connection available
    And the file isn't available locally
    When I tap the link / icon to the file
    Then I should see an error message informing me about the file being unavailable
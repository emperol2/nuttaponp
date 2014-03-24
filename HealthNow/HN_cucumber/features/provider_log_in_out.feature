#encoding: utf-8
@javascript
Feature: Provider Authentication
  Provider should be logged in with specific username/ password
  Provider should get the Patient List page

  Background:
    Given I open the website

  Scenario Outline: Successfully logged in as Provider
    Given I open the website "https://my.healthnow.net/Pages/Login.aspx"
    When I enter username and password "<username>", "<password>"
    Then I should see a "<message>"
    And the user type should be "<user_type>"

  Examples:
    | username     | password        | message | user_type |
    | sam2014      | papajohn        | valid   | Profile   |
    | papajohn_jr  | 1981papajohn_jr | invalid | no_type   |
    | drjill       | crosby          | valid   | Patient List  |
    | alian        | predator        | invalid | no_type   |

  Scenario: Successfully logged out
    Given I logged in as Provider
    When I click on profile icon at top-right
    Then I should see log out link
    And I click at the link

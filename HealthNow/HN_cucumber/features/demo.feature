#encoding: utf-8
@javascript
Feature: User Authentication
  Patient should be logged in as specific username/ password
  Patient should see the Patient profile page after successfully logged in
  
  Scenario Outline: Successfully logged in as Patient
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

#  Scenario: Successfully logged out as Patient
#    Given I am a Patient
#    When I click on menu icon at top-right
#    Then I should see the logout link
#    And I click the logout link
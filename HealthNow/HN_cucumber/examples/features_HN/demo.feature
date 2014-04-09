#encoding: utf-8
Feature: Login as Patient
  This shows a complete functionality of Login feature
  Correct Username/ Password
  Incorrect Username/ Password
  Server timeout
  Login successful
  
  Scenario: Correct Username and Password
    Given I open the website "http://qa.healthnow.com"
    When I enter username and password "test", "123"
    Then I should see a "Profile" page
    And the user profile should be "Dr. Test Lee"
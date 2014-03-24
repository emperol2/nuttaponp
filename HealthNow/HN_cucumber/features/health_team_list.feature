#encoding: utf-8
@javascript

Feature: Health team list
  The Patient can see health team list page
  The list contains groups of provider
  The Patient can Add new provider
  The patient can Edit provider

  Scenario: Patient navigate to health team list page
    Given The user logged in as patient
    And he should see the "patient profile" page
    When he click at "health team icon"
    Then he should see the "health team list" page

  Scenario: Patient attempts to add new provider
    Given he is at the health team list page
    When he click at "Add" button
    Then he should see add new provider form
    And he fills in all details "name", "relationship"
    And click "save" button

  Scenario: Patient attempts edit provider
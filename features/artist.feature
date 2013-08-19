Feature: Artists

  As a user who contributes to the site
  I would like edit, add and control content on the wiki
  
  Scenario: A user can search artists on the wiki and add a new one if the expected result is not found
    Given an artist exists
    And a user who is logged in
    When I search for an artist with the query 'brel'
    Then I should see a "Create It" link button
    And I should not see the alphabetical index links

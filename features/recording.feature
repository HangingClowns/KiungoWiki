Feature: Recordings

  As a user who contributes to the site
  I would like edit, add and control content on the wiki
  
  Scenario: A user can search recordings on the wiki and add a new one if the expected result is not found
    Given a recording exists
    And a user who is logged in
    When I search for a recording with the query 'title:"A house of pain"'
    Then I should see a "Create It" link button
    And I should not see the alphabetical index links
  
  @javascript
  Scenario: A user can preview a change before it is saved
    Given a recording exists
    And a user who is logged in
    When I update and preview a recording
    Then I should see the recording preview listed
    And a notice showing that it is a preview
    And the original recording should not be touched
    
  @javascript
  Scenario: A user can update a record after a preview
    Given I have already performed a preview on an existing recording
    When I choose to accept the update
    Then the recording should have the new data
    
  @javascript
  Scenario: A user can preview a new record before saving
    Given a user who is logged in
    When I preview a new recording
    Then I should see the recording preview listed
    And a notice showing that it is a preview
    And no new recording should have been created
    
  @javascript
  Scenario: A user can create a record after a preview
    Given I have already performed a preview for a new recording
    When I choose to accept the creation
    Then the recording should have been created
    
  Scenario: Anyone can report content when there is a supplementary section
    Given a recording with a supplementary section
    When I view this recording
    Then the report link should be visible
    
  Scenario: Anyone cannot report content when there is not a supplementary section
    Given a recording without a supplementary section
    When I view this recording
    Then the report link should not be visible
    
  Scenario: An email should be sent to the admin and reporter upon submitting a report
    Given a recording with a supplementary section
    And I view this recording
    When I report this resource
    Then the administrator and I should receive an email
    And I should be redirected to the recording
    And I should see a notice that an email has been sent
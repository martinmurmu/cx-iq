This feature is no longer required

Feature: Client can access v2p reports 
  Scenario: Client nevigates to v2p reports
    When I come to application as a client
    And I login with valid credentials
    And I click on Display welcome page
    And I clikc on V2P button
    Then I should see v2p details page
    When I select a product form autosuggest product listing
    Then I should get the satisfaction report 
    When I click on view more results
    Then I should be able to see Customer Experience (CX) Analysis Dashboard
    When I click to customize the report
    And I select attributes from attributes selector
    Then I click on apply new setting to generate report
    Then I should be able to see newly generate report with params configured by me
    When I click on export verbatim link
    Then I shold get verbatim report downloaded

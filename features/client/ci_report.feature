Feature: Client can access ci reports 
  Scenario: Client nevigates to ci reports
    When I come to application as a client
    And I login with valid credentials
    And I go to products tab
    And Add a new product
    When I click on the product title
    Then I slould see product management page
    When I click on CI analysis button
    And I select attributes from attribute selector
    Then I click on apply new settings button
    Then I should be able to see Customer Experience (CX) Analysis Dashboard
        

Feature: Client can access nps monitor reports 
  Scenario: Client nevigates to nps monitor reports
    When I come to application as a client
    And I login with valid credentials
    And I click on add list
    And I add products to that list
    And I click on my account link
    And I click on NPS monitor button
    And I select a product for nps monitor
    Then I should get the nps monitor report generated
    When I click on click to customize button
    And I select the attributes from attrbutes list
    When I click on apply new settings
    Then Customer Experience (CX) Analysis Dashboard should get generated
    

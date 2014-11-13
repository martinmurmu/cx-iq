Feature: Client can access cem intelligence reports 
  Scenario: Client nevigates to cem intelligence reports
    When I come to application as a client
    And I login with valid credentials
    And I click on Display welcome page
    And I click on cem intelligence button
    And I click on add list button
    When I fill add list form
    Then I should be able to see newly added list
    When I click on the list name
    Then I should be able to product autosuggest selector
    When I fillup the product name and search
    Then I should be able to see all the associated products listed
    When  I click on add to my list button of a product
    Then Product should get added to my product list
    When I click on Product MIA report
    Then I should get message saying Thank you. Your customized report is being generated and will be emailed to you shortly.    

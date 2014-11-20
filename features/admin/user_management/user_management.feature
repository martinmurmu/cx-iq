Feature: Admin can manage user limitation and login  
  Scenario: Admin manages user limitation
    Given A user has signed up to application and requested for permission to generate report
    When I come to application as admin
    And I login with valid credentials of administrator
    And I go to user management section
    Then I should be able to see users listing with pagination
    When I click on user create limitation link
    And I set limitations for the user
    Then limitations should be configured for the user    
    

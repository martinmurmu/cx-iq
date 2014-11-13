Feature: Client can access his basic content
  Scenario: Client comes to the application first time after configuring the account
    When I come to application as a client
    And I click on customer login link on homepage
    Then I should get sign in form
    When I put my user credentials there
    Then I should get user information edit form
    When I updpdate my details there
    Then My details should get updated in the system
    When I click on request a demo button
    Then I should be nevigated to demo information form
    When I come to the edit user information page again
    And I click on Display welcome page
    Then I should be able to see welcome message

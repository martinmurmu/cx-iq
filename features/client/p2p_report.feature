Feature: Client can access p2p reports 
  Scenario: Client nevigates to p2p reports
    When I come to application as a client
    And I login with valid credentials
    And I click on Display welcome page
    And I click on P2P button
    Then he should be nevigated to www.what-is-the-best-phone-for-me.com

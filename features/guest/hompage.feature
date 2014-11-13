Feature: Guest user can access static content
  Scenario: Guest user comes to the application
    When I come to application as a guest user
    Then I should be able to home page
    And I should be able to see download link to recipe for revenue growth
    When I click on recipe for revenue growth link
    Then I should be able to see user information form with captcha
    And Clicking on subscribe should take me to subscribe feed xml
    When I fill up the user information form
    Then I should get message for white paper requested shall be emailed to me
    And When I click subscribe button on the page
    Then I should see the feedburner page for assign feed
    When I click on products link
    Then I should be able to see 3 tabs describing the service
    When I click on download process description button
    Then I should get user information form
    When I fill up the user information form
    Then I should get message for white paper requested shall be emailed to me
    When I click on social NPS ondemand locator
    Then I should be able to see social nps information form
    When I click on request a demo button
    Then I should see demo request form with captcha
    When I fillup demo request form
    #TODO Rectify this error from the application
    Then I see an error page 
    When I go to products page
    And I click on customer intelligence link
    Then I should see customer intelligence details 
    When I click on donwload white paper button
    Then I should see user infromation form
    When I click on case studies button then I should be able to see case studies page
    When I click on schedule a live demo button
    Then I should be able to see schedule demo form
    When I fill up the schedule demo form
    Then I should be nevigated to meetme.com site to schedule demo with Gregory Yankelovich
    When I click on services link
    Then I should be able to see the services details with link to download ebook Power of social consumer
    When I click on download ebook Power of social consumer
    When I fill up the user information form
    When I click on methodology button
    Then I should see methodology static page
    When I click on blog link
    Then I should be nevigated to blog.cx-iq.com page
    When I click on contect form
    Then I should see contact information form
    When I fillup contact information form
    Then I should get message thankyou for your interest    
    

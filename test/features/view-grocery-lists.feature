  Scenario: Authenticated user visits "/"
    Given a user exists with email "bernard@ww.com"
    And I am logged in as "bernard@ww.com"
    And I navigate to "/"
    Then I am redirected to "user/bernard/lists/"
    And the page contains the text "My Grocery Lists 
  
  Scenario: Authenticated user visits "/user/<username>/lists"
    Given I am logged in as "bernard@ww.com"
    And I am visit "/user/bernard/lists/"
    Then the page contains the text "My Grocery Lists 

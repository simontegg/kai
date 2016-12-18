Feature: Frontpage Form
  Scenario: Unauthenticated user visits frontpage
    Given I have not authenticated 
    And I navigate to "/"
    Then the page contains the text "Optimise my groceries" 
    Then the page contains the legend "Your Details"

Feature: Frontpage Form
  Scenario: Unauthenticated user visits frontpage
    Given I am not logged in
    And I navigate to "/"
    Then the page contains the legend "Your Details"
    Then the page contains the text "Optimise my groceries" 

  Scenario: Authenticated user visits frontpage
    Given a user exists with email "bernard@ww.com"
    And I am logged in as 
    And I navigate to "/"
    Then I am redirected to "user/bernard/lists/"
    Then the page contains the text "My Grocery Lists 

  Scenario: Unauthenticated user enters details
    Given I am not logged in
    And I navigate to "/"
    When I fill "email" with <email>
    When I fill "age" with <age>
    When I fill "height" with <height>
    When I fill "weight" with <weight>
    When I fill "workouts" with <workouts>
    When I select "sex" <sex>
    When I press "Optimise my groceries"
    Then the page contains the text "Kai is computing your groceries" 
    Then the page contains the text "We've sent you an email" 
    Then an email with the subject "your grocery list" is sent to <email>

    Examples:
     email       | age | height | weight | workouts | sex    |
     ben@ben.com | 32  |   167  |  70    | 0        | male   |
     sam@sam.com | 54  |   178  |  85    | 4        | female |

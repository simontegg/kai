Feature: Compute groceries from user details
  Scenario: Unauthenticated user visits "/"
    Given I am not logged in
    And I navigate to "/"
    Then I should see the "start" page

  Scenario: Unauthenticated user enters details
    Given I am not logged in
    And I navigate to "/"
    When I fill in the user-details form
    And I click "Optimise my groceries"
    Then the page contains the text "Kai is computing your groceries" 
    #  Then the page contains the text "We've sent you an email" 
    Then an email with the subject "your grocery list" is sent to <email>
    #computations?
    # make height, weight, workouts optional?

  Scenario: Authenticated user visits "/users/<username>/edit"
    Given I am logged in as "bernard@ww.com"
    And I visit "/user/bernard/edit"
    Then I should see the "edit" page
  
  Scenario: Authenticated user updates details
    Given I am logged in as "bernard@ww.com"
    And I visit "/user/bernard/edit"
    When I fill "workouts" with 4
    And I click "Save my settings"
    Then I see the text "updating your groceries"

    #TODO edit detail

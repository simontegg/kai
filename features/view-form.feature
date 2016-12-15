Feature: Test Frontpage
  Scenario: Test Frontpage form loads
    Given I navigate to "/"
    Then the page contains the legend "Your Details"

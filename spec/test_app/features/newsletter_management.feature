Feature: Newsletter Management
  In order to create newsletters
  As a valid user
  I want to create, modify, and publish newsletters

  Background:
    Given I am logged in and authorized for everything 
      And a design named "Bobo's Design" exists
  
  Scenario: Create a new newsletter
    When I go to the newsletters page
     And I follow "New Newsletter"
     And I fill in "Name" with "Bobo's first Newsletter"
     And I press "Save"
    Then a newsletter named "Bobo's first Newsletter" should exist
     And that newsletter should have the design named "Bobo's Design"
    

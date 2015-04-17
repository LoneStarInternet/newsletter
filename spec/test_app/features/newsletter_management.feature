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
    
  Scenario: Edit a newsletter
   Given a newsletter named "Bobo's first Newsletter" exists
    When I go to the newsletters page
     And I follow "Edit"
     And I fill in "Name" with "Bobo's Great Newsletter"
     And I press "Save"
    Then a newsletter named "Bobo's Great Newsletter" should exist

  Scenario: View a newsletter on the archive page
   Given a newsletter named "Bobo's first Newsletter" exists
    When I go to the newsletters page
     And I follow "Publish"
     And I go to the newsletter archive page
     And I follow "Bobo's first Newsletter"
    Then I should see "Bobo's first Newsletter"

  Scenario: Newsletters have pagination
   Given 50 newsletters exist
    When I go to the newsletters page
    Then I should see "Previous"
     And I should see "Next"
    When I follow "Next"

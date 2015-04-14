Feature: Piece Management
  In order to add content to newsletters
  As a valid user
  I want to create, modify, delete pieces

  Background:
    Given I am logged in and authorized for everything 
      And a design named "Bobo's Design" exists
      And a newsletter named "Bobo's Newsletter" exists with design named "Bobo's Design"

  Scenario: Add an inline asset piece with a url
    When I go to the newsletters page
     And I follow "Edit"
     And I select to add a "Left Column Image" from the "Left column" area
     And I press the "Left column" area's "Add Element" button
    Then I should be on newsletter named "Bobo's Newsletter"'s new piece page
     And I fill in "Url:" with "http://www.google.com/favicon.ico"
     And I press "Submit"
    Then a "Left Column Image" should exist in "Bobo's Newsletter"'s "Left Column" are with an "image" url of "http://www.google.com/favicon.ico"


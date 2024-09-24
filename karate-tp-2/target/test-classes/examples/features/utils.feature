@ignore
Feature: Retrive availabale and not availabale books 

 Background:
    * url baseUrl

 @getBooks
Scenario: retrieve availabale books 
    Given path 'books'
    When method GET 
    Then status 200
    * def books = $response[*]
    

    
   

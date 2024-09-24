@ignore
Feature: acces to the api 
    Background:
        * url baseUrl
        
    @login
    Scenario: Login  
        Given path '/api-clients/'
        And def auth = read('classpath:examples/data/credentialAuth.json')
        And auth.clientEmail = 'youness' + Math.random() + '@gmail.com'
        And request auth
        When method POST
        Then status 201
        * def accessToken = response.accessToken
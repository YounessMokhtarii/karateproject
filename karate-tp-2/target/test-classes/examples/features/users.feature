@BookFeature
Feature: first karate api
 Background:
    * url baseUrl
    * def signIn = karate.callSingle('login.feature@login')
    * def model = read('classpath:examples/test-data/modelBook.json')
    * def modelByID = read('classpath:examples/test-data/modelbookbyid.json')
    * def book = read('classpath:examples/data/petStore.json')
    * def token = signIn.accessToken
    * def Authorization = 'Bearer '+ token
    * def booksRespnse = karate.callSingle('utils.feature@getBooks')
    * def books = booksRespnse.books
    * configure retry = { count: 5, interval: 1000 }



 @getBooks
 Scenario:  Retrieve and Validate All books
    Given path 'books'
    And header Authorization = Authorization
    When method GET 
    Then status 200
    * match each response == model.book

   
 @simpleTest
  Scenario: Retrieve and Validate
    * def counter = 0
    * def incrementCounter = function(x){return  x + 1}
    * def result = incrementCounter(counter) 
    * print result
    * retry until result > 3
    

   
 @getBookWithfilter
 Scenario Outline:  Filter and Retrieve books and Validate the Response    
    Given path 'books'
    And header Authorization = Authorization
    And params {'type': '<type>'}
    When method GET 
    Then status 200
    * def rep = response
    #* def types = karate.map(rep,function(x){return x.type})
    * def types = $response[*].type
    * match each types == '<type>'
    Examples:
    | read('classpath:examples/data/data.csv') |


 @getBooksAndverifyIdNotNull
 Scenario:  Retrieve  All books and verify id not null
    Given path 'books'
    And header Authorization = Authorization
    When method GET 
    Then status 200
    * match each $ contains {id: "#notnull"}

 @getBooksAndValidateID   
  Scenario: Retrieve All books and validte the unicity of id 
    Given path 'books'
    And header Authorization = Authorization
    When method GET 
    Then status 200
    * def rep = $response[*].id
    * def ids = karate.distinct(rep)
    * match karate.sizeOf(ids) == karate.sizeOf(rep)
    
 @getOrders
 Scenario: Retrieve All Orders 
    Given path 'orders'
    And header Authorization = Authorization
    When method GET 
    Then status 200
    And print 'after get', response
    
   @createOrderWithAvailablebook
   Scenario Outline: Create order with an available book
      Given path 'orders'
      And header Authorization = Authorization
      * def availableBooks = karate.filter(books,function(x){return x.available == true})
      * def availableBook = $availableBooks[0]
      * book.bookId = availableBook.id
      * book.customerName = '<customerName>'
      And request book
      When method POST
      Then status 201
      * def order = response 
      Examples:
      | customerName |
      | Ahmed    |


   @deleteOrder
   Scenario: Delete order 
      * path 'orders'
      * header Authorization = Authorization
      * def orderReq = karate.callSingle('@createOrderWithAvailablebook')
      * def order = orderReq.order   
      * def orderId = order.orderId
      * path orderId
      * method DELETE
      * status 204
      * path orderId
      * method GET
      * status 404  

   @getOrderByID
   Scenario: Retrieve Order 
      * path 'orders'
      * header Authorization = Authorization
      * def orderReq = karate.callSingle('@createOrderWithAvailablebook')
      * def order = orderReq.order   
      * def orderId = order.orderId
      * path orderId
      * method GET
      * print 'after get', response
   @getBookById
   Scenario:  Retrieve book with id  <bookId>
      Given path 'books'
      * def bookId = $books[0].id
      And path bookId
      And header Authorization = Authorization
      When method GET 
      Then status 200
      * match response == modelByID.book
      
      
   @createOrderWithNotAvailablebook
   Scenario Outline: Create order with non  available book
      Given path 'orders'
      And header Authorization = Authorization
      * def notAvailablesBooks = karate.filter(books,function(x){return x.available == false})
      * def notAvailableBook = $notAvailablesBooks[0]
      And book.bookId = notAvailableBook.id
      And book.customerName = '<customerName>'
      And print 'after update', book
      And request book
      When method POST
      Then status 404
      Examples:
      | customerName |
      | Ahmed    |

   
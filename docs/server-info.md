# Server Information

The API can be accessed at the url: 

https://beakr-api.herokuapp.com/

## Current Endpoints

The current endpoints and their formats that are currently implemented are:

* /user
  * GET /user/:id returns the user with the designated id
* /users
  * GET returns a list of all users and their ids
* /student 
  * POST - parses a new student and creates the proper user entry
    ```json 
    {
      "name": name,
      "email": email@domain,
      "standing": Freshman, Sophomore, Junior, Senior,
      "major": major
    }
    ```
* /offering
  * POST - creates a new offering 
* /offerings
  * GET - retrieves a list of all offerings
* /message
  * GET - /message/:id
  * POST 
* /messages
  * GET - returns a list of all messages

# Lunch and Learn
## Overview
Lunch and Learn is a Rails-based API that allows users to register, authenticate, and manage their favorite recipes. The API provides endpoints for user registration, user sessions, and managing favorites.

## Learning Goals
- Understand and implement authentication and authorization in a Rails API.
- Utilize BCrypt for password encryption.
- Implement secure API key generation and management.
- Handle JSON payloads in HTTP requests.
- Manage one-to-many relationships in a database (User -> Favorites).
- Write RSpec tests for API endpoints.

## Setup Instructions
### Prerequisites
Ensure you have the following installed:

- Ruby (version 3.2.2+)
- Rails (version 7.0+)
- PostgreSQL

### Clone the Repository
```bash
git clone https://github.com/Steddy1Love/lunch_and_learn.git
cd lunch_and_learn
```

### Install Dependencies
```bash
bundle install
Set Up the Database
```
### Create and migrate the database:
```bash
rails db:create
rails db:migrate
```

### Get API Keys
This project may require external API keys. You can obtain them from:

[Geoapify](https://www.geoapify.com/)
[Google](https://console.cloud.google.com/apis/library?pli=1)
[Edamam](https://developer.edamam.com/edamam-docs-recipe-api)
[Pexel](https://www.pexels.com/api/documentation/?#photos-search)

### Configure Environment Variables
Create a .env file in the root directory and add your API keys:

GEOAPIFY_API_KEY=your_geoapify_api_key
OTHER_API_KEYS=your_other_api_key

### Start the Server
```bash
rails server
```
Your API should now be running on http://localhost:3000.

## API Endpoints
### User Registration
Request:

```http
POST /api/v1/users
Content-Type: application/json
Accept: application/json

{
  "name": "Odell",
  "email": "goodboy@ruffruff.com",
  "password": "treats4lyf",
  "password_confirmation": "treats4lyf"
}
```
Response:

```json
{
  "data": {
    "type": "user",
    "id": "1",
    "attributes": {
      "name": "Odell",
      "email": "goodboy@ruffruff.com",
      "api_key": "jgn983hy48thw9begh98h4539h4"
    }
  }
}
```
### User Login
Request:

```http
POST /api/v1/sessions
Content-Type: application/json
Accept: application/json

{
  "email": "goodboy@ruffruff.com",
  "password": "treats4lyf"
}
```
Response:

```json
{
  "data": {
    "type": "user",
    "id": "1",
    "attributes": {
      "name": "Odell",
      "email": "goodboy@ruffruff.com",
      "api_key": "jgn983hy48thw9begh98h4539h4"
    }
  }
}
```
### Add Favorite
Request:

```http
POST /api/v1/favorites
Content-Type: application/json
Accept: application/json

{
  "api_key": "jgn983hy48thw9begh98h4539h4",
  "country": "thailand",
  "recipe_link": "https://www.tastingtable.com/.....",
  "recipe_title": "Crab Fried Rice (Khaao Pad Bpu)"
}
```
Response:

```json
{
  "success": "Favorite added successfully"
}
```
### Get Favorites
Request:

```http
GET /api/v1/favorites?api_key=jgn983hy48thw9begh98h4539h4
Content-Type: application/json
Accept: application/json
```
Response:

```json
{
  "data": [
    {
      "id": "1",
      "type": "favorite",
      "attributes": {
        "recipe_title": "Recipe: Egyptian Tomato Soup",
        "recipe_link": "http://www.thekitchn.com/recipe-egyptian-tomato-soup-weeknight....",
        "country": "egypt",
        "created_at": "2022-11-02T02:17:54.111Z"
      }
    },
    {
      "id": "2",
      "type": "favorite",
      "attributes": {
        "recipe_title": "Crab Fried Rice (Khaao Pad Bpu)",
        "recipe_link": "https://www.tastingtable.com/.....",
        "country": "thailand",
        "created_at": "2022-11-07T03:44:08.917Z"
      }
    }
  ]
}
```
## Testing
Run the tests with:

```bash
bundle exec rspec
```

Ensure all tests are passing before deploying or merging new code.

## Contributions
Contributions are welcome! Please open a pull request with your changes or create an issue to discuss any potential changes.

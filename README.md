# This is a simple JSON API service

# REST API application

This is a simple JSON API service written using Sinatra.

The entire application is contained within the `app.rb` file.

## Install

    docker-compose build app
    docker-compose run --rm app bundle install
    docker-compose run --rm app bundle exec rake db:create
    docker-compose run --rm app bundle exec rake db:migrate

## Run the app

    docker-compose up app

## Prepopulate DB

    docker exec -ti blog_app_1 bundle exec rake db:seed

## Run the tests

    docker-compose run --rm app bundle exec rake db:test:prepare
    docker-compose run --rm app bundle exec rspec spec

# REST API

## Create new Post

### Request

`POST /api/v1/post`

    curl -d '{"title": "title1", "content": "content1", "login": "user1"}' -H "Content-Type: application/json" -X POST http://localhost:4567/api/v1/post

## Rate existed post

### Request

`POST /api/v1/rate`

    curl -d '{"post_id": "1", "rate": "4"}' -H "Content-Type: application/json" -X POST http://localhost:4567/api/v1/rate

## Returns list of top N posts with provided average rate

### Request

`POST /api/v1/posts`

    curl -d '{"count": 5, "rate": 3}' -H "Content-Type: application/json" -X POST http://localhost:4567/api/v1/posts


## Returns users id with specified ips

### Request

`POST  /api/v1/ips`

    curl -d '{"users": [1, 2, 3]}' -H "Content-Type: application/json" -X POST http://localhost:4567/api/v1/ips

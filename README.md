# README

## Client apps link: https://github.com/AbdusSattar-70/MingleMate_client

## Full API documentation will be coming soon.

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

## AWS setup for deployment:

- add gem `sidekiq`
- add gem `redis`
- run `EDITOR="code --wait" bin/rails credentials:edit --environment=production` for generating production-key
- add environment variable.

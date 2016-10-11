# Dckerize
[![Gem Version](https://badge.fury.io/rb/dckerize.svg)](http://badge.fury.io/rb/dckerize)
[![Build Status](https://travis-ci.org/pacuna/dckerize.svg?branch=master)](https://travis-ci.org/pacuna/dckerize)

Supercharged Rails development using Docker

## Description

This gem gives you a good starting point to containerize your Rails 5 applications using Docker.

You'll get

- An nginx/passenger container environment for your application and all the necessary configurations. It also mounts the application into the container so you can make development changes and not having to rebuild the image.
- A separate container running MySQL or PostgreSQL
- A separate container for keeping your data using the data-only container pattern.
- Extras (elasticsearch, redis and memcached for now)

## Requirements

- Docker >= 1.12
- Docker Compose >= 1.8

## Installation

    $ gem install dckerize

## Usage

### Quickstart

[![Dckerize](http://img.youtube.com/vi/PGlPKbHIOBc/0.jpg)](http://www.youtube.com/watch?v=PGlPKbHIOBc "Dckerize Quickstart")

You need to have a Rails 5 application already created. It can be useful if you
create your app using the `--database` flag so you can have the driver already configured.

General usage:

    $ dckerize up APP_NAME --database=<mysql|postgres> [--extras=elasticsearch,redis,memcached]

So for example in the root of your application run:

    $ dckerize up APP_NAME --database=mysql

Or

    $ dckerize up APP_NAME --database=postgres

Or

    $ dckerize up APP_NAME --database=postgres --extras=elasticsearch,redis

Where APP_NAME should be the same name of your application and you must specify the database
that you want to use.

## Database Configuration

After running the `up` command you have to configure your database credentials
in the following way:

### MySQL
In your config/database.yml add these lines to your configuration:

    username: root
    password: mysecretpassword
    host: mysql

### Postgres
In your config/database.yml add these lines to your configuration:

    username: APP_NAME
    password: mysecretpassword
    host: postgres

You can change these values in the `docker-compose.yml` file.

Once you have your database configured, you can run:

```
$ docker-compose up --build
```
## Tips

### Create a new Rails app with Docker

    $ docker run -it --rm --user "$(id -u):$(id -g)" -v "$PWD":/usr/src/app -w /usr/src/app rails rails new --skip-bundle --database=postgresql webapp
    
    $ cd webapp
    
    $ docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:2.3 bundle install
    
    
### Redirect logging to STDOUT

Add to you `config/application.rb` file:

    config.logger = ActiveSupport::Logger.new(STDOUT)

### Run tasks

You can run tasks directly using Docker Compose run command:

    docker-compose run --rm webapp bin/rails db:migrate
    docker-compose run --rm webapp bin/rails g scaffold users name email password
    
Or you can open a session inside the container and run your commands there:

    docker-compose exec webapp bash
    # bin/rails db:migrate

## Contributing

1. Fork it ( https://github.com/pacuna/dckerize/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

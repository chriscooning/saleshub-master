## Requirements
* Ruby 2.1.0+
* PostgreSql 9+

## Setup
* `bundle exec rake db:setup`

## Deploy

### Deploy to staging
* `$ cap deploy`

### Deploy to production
* `$ cap production deploy`

### Usefull commands
* deploy with migrations:
* `$ cap deploy:migrations`
* connect via ssh:
* `$ cap ssh`
* show application logs:
* `$ cap log`
* start rails console:
* `$ cap console`
* [see more](https://github.com/capistrano/capistrano/wiki/Capistrano-Tasks)
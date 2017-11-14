source 'https://rubygems.org'

gem 'rails', '4.0.2'
gem 'sass-rails', '~> 4.0.0'

gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

# database gems
gem 'pg'
gem 'data_migrate'
gem 'annotate'
gem 'ransack'

# RSS
gem 'feedzirra'

# json serialization
gem 'oj'
gem 'active_serializer', github: 'droidlabs/active_serializer'

# recurring tasks/cron management
gem 'whenever', require: false

# Authentication
gem 'devise'

# Authorization
gem 'cancan'

# Sanitize HTML
gem 'sanitize'

# Geo
gem 'us_states', github: 'byronanderson/us_states'

# pagination
gem 'will_paginate'

# templating
gem 'slim-rails'

# ui helpers
gem 'simple_form'

# decoration
gem 'draper'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
#gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# bootstrap
gem 'bootstrap-sass'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Settings
gem 'configatron'

gem 'navigation_link_to'

# error tracking
gem 'rollbar'

# API
gem 'rest-client'

# Client-side templates
gem 'skim', '0.9.3'

# net-ssh hack
gem 'net-ssh', '2.7.0'

# tracking
gem 'newrelic_rpm'

# wysiwyg
gem 'bootsy'
gem 'truncate_html'

gem 'jquery-fileupload-rails'
gem 'fancybox-rails', github: 'ilnuryakupov/fancybox-rails'

gem 'carrierwave'
gem 'fog'

# IE HTML5 placeholder support
gem 'jquery-placeholder-rails'

gem 'faye'

gem 'gritter', github: 'RobinBrouwer/gritter'

gem 'cyrax'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'therubyracer', platforms: :ruby, require: 'v8'

group :development do
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'letter_opener', github: 'droidlabs/letter_opener'

  gem 'capistrano', '2.15.5', require: false
  gem 'capistrano-rbenv', require: false
end

group :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'capybara' # browser emulation
  gem 'timecop'  # time cheats
  gem 'webmock' # web stubbing
  gem 'vcr' # external API stubbing
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

gem 'byebug', group: [:development, :test]

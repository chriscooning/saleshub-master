require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'rollbar/capistrano'
require "whenever/capistrano"

set :rollbar_token, '####'
set :whenever_command, "bundle exec whenever"

set :stages, %w(staging production)
set :default_stage, "staging"
set :deploy_via, :remote_cache
set :keep_releases, 5
set :scm, :git

before  'deploy:setup', 'db:create_config'
#after   'deploy:setup', 'deploy:first'

before  'bundle:install',  'rbenv:create_version_file'

after   'deploy:finalize_update', 'db:create_symlink'
after   'deploy:create_symlink', 'deploy:cleanup'
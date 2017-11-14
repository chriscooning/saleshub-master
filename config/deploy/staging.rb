set :dns_name, "#"

set :default_environment, {
  'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
}

set :application, "saleshub"
set :repository,  "git@github.com:omggroup/saleshub.git"

role :web, dns_name                          # Your HTTP server, Apache/etc
role :app, dns_name                          # This may be the same as your `Web` server
role :db,  dns_name, primary: true           # This is where Rails migrations will run

set :deploy_to, "/data/#{application}"

set :rails_env, 'staging'
set :branch, 'master'
set :use_sudo, false

set :user, 'saleshub'
set :password, '####'
set :port, 22

set(:rbenv_ruby_version, '2.1.5')
set(:rake_cmd) {"#{bundle_cmd rescue 'bundle'} exec rake RAILS_ENV=#{rails_env}"}
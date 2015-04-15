# Adapted from http://wagn.org/Puma_and_Nginx_production_stack
application_path = '/var/www/rails'
railsenv = ENV['RAILS_ENV'] || 'development'
directory application_path
environment railsenv
daemonize true
pidfile "#{application_path}/tmp/pids/puma-#{railsenv}.pid"
state_path "#{application_path}/tmp/pids/puma-#{railsenv}.state"

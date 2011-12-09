require 'bundler/capistrano'

set :application, "elzar-test"
set :repository,  "."
set :deploy_via, :copy

set :scm, :git
set :user, 'deploy'
set :deploy_to, "/var/www/apps/#{application}"
default_run_options[:pty] = true
set :ssh_options, { :paranoid => false, :forward_agent => true }

role :web, "172.25.5.5"
role :app, "172.25.5.5"
role :db,  "172.25.5.5", :primary => true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

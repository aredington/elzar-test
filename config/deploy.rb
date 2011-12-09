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

after "deploy:setup", "elzar_test:copy_shared_db_config"
after "deploy:symlink", "elzar_test:symlink_shared_db_config"
before "deploy:migrate", "elzar_test:ensure_db_created"

namespace :elzar_test do
  task :copy_shared_db_config do
    run "mkdir -p #{shared_path}/config"
    #Capistrano::Configuration::Actions::FileTransfer.upload
    upload("config/database.example.yml", "#{shared_path}/config/database.yml", :via => :scp)
  end

  task :ensure_db_created do
    run "cd #{release_path} && #{rake} db:create"
  end

  task :symlink_shared_db_config do
    run "ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml"
  end
end

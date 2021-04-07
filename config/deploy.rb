# config valid for current version and patch releases of Capistrano
lock '~> 3.16.0'
set :rbenv_ruby, '2.6.6'

set :application, 'church_flow'
set :repo_url, 'git@github.com:kajabijamell/sda-live.git'
set :rails_env, fetch(:stage).to_s
set :deploy_to, "/home/ubuntu/#{fetch(:application)}"

set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/master.key', 'config/application.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

set :keep_releases, 5

set :ssh_options, forward_agent: true, keys: %w[~/.ssh/id_rsa.pub]

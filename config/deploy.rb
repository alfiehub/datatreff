require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'    # for rvm support. (http://rvm.io)
#require 'mina/deploy' # so we can deploy

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

print "Username @ compo.galaxelan.no (defaults to current user's username): "
username = STDIN.gets.chomp
set :user, username unless username == ''

set :domain, 'compo.galaxelan.no'
set :deploy_to, '/var/www/party.galaxelan.no'
set :repository, 'git@github.com:alfiehub/datatreff.git'
set :branch, 'master'

# For system-wide RVM install.
set :rvm_path, "$HOME/.rvm/scripts/rvm"

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use', 'ruby-2.4.1'
end

desc "Deploys the current version to the server."
task :deploy do
  deploy do
    command 'git checkout master'
    command 'git fetch'
    command 'git reset --hard origin/master'
    invoke :'bundle:install'
    invoke :'rake', 'db:migrate RAILS_ENV=production'
    invoke :'rake', 'assets:precompile RAILS_ENV=production'
    invoke :'rake', 'tmp:cache:clear RAILS_ENV=production'
    command 'touch tmp/restart.txt'
  end
end

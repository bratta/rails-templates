# Setup a basic deploy.rb file with eycap recipe dependencies

# The application name is not passed to the templates in 2.3 RC1, so 
# we need to do a bit of magic to get at it if we need to get it.
application = @root.match(/([-\w]+)$/)[0]

if yes?("Generate a skeleton deploy.rb file?")
  capify!
  file "config/deploy.rb", <<-EOF
# Please install the Engine Yard Capistrano gem
# gem install eycap --source http://gems.engineyard.com

require "eycap/recipes"

# =============================================================================
# ENGINE YARD REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The :deploy_to variable must be the root of the application.

set :keep_releases,       5
set :application,         "#{application}"
set :repository,          ""
set :user,                ""
set :password,            ""
set :deploy_to,           ""
set :deploy_via,          :remote_cache
set :repository_cache,    ""

# This will execute the Git revision parsing on the *remote* server rather than locally
set :real_revision,       lambda { source.query_revision(revision) { |cmd| capture(cmd) } }

set :monit_group,         "#{application}"
set :scm,                 :git
set :runner,              ""
set :branch,              "master"

set :production_database, "#{application}_production"
set :production_dbhost,   "localhost"

set :staging_database, "#{application}_staging"
set :staging_dbhost,   "localhost"

set :dbuser,        "#{application}_db"
set :dbpass,        ""

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false
    
# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

task :production do

  role :web, "APPLICATION_HOST"
  role :app, "APPLICATION_HOST", :mongrel => true
  role :db , "APPLICATION_HOST", :primary => true


  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

task :staging do

  role :web, "APPLICATION_HOST"
  role :app, "APPLICATION_HOST", :mongrel => true
  role :db , "APPLICATION_HOST", :primary => true


  set :rails_env, "staging"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

# =============================================================================
# Any custom after tasks can go here.
# after "deploy:symlink_configs", "#{application}_custom"
# task :#{application}_custom, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
#   run <<-CMD
#   CMD
# end
# =============================================================================

after "deploy", "deploy:cleanup"
after "deploy:migrations" , "deploy:cleanup"
after "deploy:update_code", "deploy:symlink_configs"

# uncomment the following to have a database backup done before every migration
# before "deploy:migrate", "db:dump"
EOF
end
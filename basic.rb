# Generate a very basic Rails 2.3 application

# General plugins
plugin 'rspec',                  :git => 'git://github.com/dchelimsky/rspec.git'
plugin 'rspec-rails',            :git => 'git://github.com/dchelimsky/rspec-rails.git'
plugin 'asset_packager',         :git => 'http://synthesis.sbecker.net/pages/asset_packager'
plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'
plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git'
plugin 'exception_notifier',     :git => 'git://github.com/rails/exception_notification.git'

# Fix for restful-authentication with Rails > 2.1
run "mv vendor/plugins/restful-authentication vendor/plugins/restful_authentication"

# Gems, gem is outrageous
# WARNING: In 2.3 RC1, there is a bug that prevents gem:install from working properly
# See this for more details: 
# http://rails.lighthouseapp.com/projects/8994/tickets/1750-session_store-initializer-causes-rakegems-tasks-to-break
gem 'ruby-openid',          :lib => 'ruby-openid'
gem 'RedCloth',             :lib => 'redcloth'
gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
gem 'capistrano',           :lib => 'capistrano'
gem 'engineyard-eycap',     :lib => 'eycap',         :source => 'http://gems.github.com'
rake("gems:install", :sudo => true)

# Generate a default controller
home_controller = ask "Enter the name of your default home controller, or leave blank for none: "
if !home_controller.blank?
  generate :controller, home_controller
  route "map.root :controller => '#{home_controller}'"
  run "rm public/index.html"
end

generate :rspec

load_template "http://github.com/bratta/rails-templates/raw/master/capistrano_deploy.rb"
load_template "http://github.com/bratta/rails-templates/raw/master/git.rb"
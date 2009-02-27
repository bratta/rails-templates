# Optional Git Repository Creation
if yes?("Would you like to place this new app in a git repository?")
  git :init
  run "echo 'TODO: Add README content here!' > README"
  run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
  run "cp config/database.yml config/example_database.yml"

  file ".gitignore", <<-EOF
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
EOF
  git :add => ".", :commit => "-m 'Initial Commit'"
end
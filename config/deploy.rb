# = Capistrano deployment for Ignite Proposals application
#
# To deploy the application using Capistrano, you must:
#
#  1. Create a "config/secrets.yml" file from the "config/secrets.yml.sample"
#     file. This will be will be uploaded to the servers by the "deploy:setup"
#     step. Do not simply run using the default because it uses publicly-known
#     keys that will let others compromise your application, and you will also
#     not be notified of exceptions. That would be bad.
#
#  2. Install the Capistrano multistage extension on the machine running the
#     `cap` command:
#       sudo gem install capistrano-ext
#
#  3. Create or use a stage file as defined in the "config/deploy/" directory.
#     Read the other files in that directory for ideas.
#
#  4. Specify the stage in all your deploy calls, e.g.,:
#       cap igniteportland deploy
#
#  5. Setup your servers if this is the first time you're deploying, e.g.,:
#       cap igniteportland deploy:setup
#
#  6. Push your revision control changes and then deploy, e.g.,:
#       cap igniteproposals deploy
#
#  7. If you have migrations that need to be applied, deploy with them, e.g.,:
#       cap igniteproposals deploy:migrations

ssh_options[:compression] = false

set :application, "openproposals"
set :use_sudo, false

# Load stages from config/deploy/*
set :stages, Dir["config/deploy/*.rb"].map{|t| File.basename(t, ".rb")}
require 'capistrano/ext/multistage'

# :current_path - 'current' symlink pointing at current release
# :release_path - 'release' directory being deployed
# :shared_path - 'shared' directory with shared content

namespace :deploy do
  desc "Restart Passenger application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t.inspect} task is a no-op with Passenger"
    task t, :roles => :app do
      # Do nothing
    end
  end

  desc "Prepare shared directories"
  task :prepare_shared do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/db"
  end

  desc "Upload config/secrets.yml to server's shared directory"
  task :upload_secrets_yml do
    put File.read("config/secrets.yml"), "#{shared_path}/config/secrets.yml", :mode => 0664
  end

  desc "Finish update"
  task :finish do
    # Gems
    run "cd #{release_path} && (bundle check --path=../../shared/gems || bundle --without=development:test --path=../../shared/gems)"

    # Theme
    put theme, "#{release_path}/config/theme.txt"

    # Secrets
    source = "#{shared_path}/config/secrets.yml"
    target = "#{release_path}/config/secrets.yml"
    begin
      run %{if test ! -f #{source}; then exit 1; fi}
      run %{ln -nsf #{source} #{target}}
    rescue Exception => e
      puts <<-HERE
ERROR!  You must have a file on your server to store secret information.
        See the "config/secrets.yml.sample" file for details on this.
        You will need to upload your completed file to your server at:
            #{source}
      HERE
      raise e
    end

    # Database
    source = "#{shared_path}/config/database.yml"
    target = "#{release_path}/config/database.yml"
    begin
      run %{if test ! -f #{source}; then exit 1; fi}
      run %{ln -nsf #{source} #{target}}
    rescue Exception => e
      puts <<-HERE
ERROR!  You must have a file on your server with the database configuration.
        This file must contain absolute paths if you're using SQLite.
        You will need to upload your completed file to your server at:
            #{source}
      HERE
      raise e
    end
  end

  desc "Clear the application's cache"
  task :clear_cache do
    run "(cd #{current_path} && rake RAILS_ENV=production clear)"
  end
end

# Hooks
after "deploy:setup", "deploy:prepare_shared"
after "deploy:setup", "deploy:upload_secrets_yml"
after "deploy:finalize_update", "deploy:finish"
after "deploy:symlink", "deploy:clear_cache"

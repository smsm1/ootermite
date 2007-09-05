require 'mongrel_cluster/recipes'

set :application, "reporter"
set :repository,  "http://ootermite.googlecode.com/svn/trunk/#{application}"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"
set :deploy_to, "/home/buildmaster/#{application}"

set :user, "buildmaster"
set :deploy_via, :export

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "termite.go-oo.org"
role :web, "termite.go-oo.org"
role :db,  "termite.go-oo.org", :primary => true

namespace :deploy do
  task :restart, :roles => :app do
    restart_mongrel_cluster
  end

  task :start, :roles => :app do
    start_mongrel_cluster
  end

  task :stop, :roles => :app do
    stop_mongrel_cluster
  end
end

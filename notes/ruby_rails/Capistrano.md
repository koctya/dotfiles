# [Capistrano](https://github.com/capistrano/capistrano)
### Capistrano helpers? Capistrano-helpers!
Let’s say you are using capistrano for your deployments. And linking files by hand is absolutely a normal usage:

        namespace :deploy do
          desc "Preserve shared files"
          task :restore_shared, :roles => [:web, :app] do
            run <<-EOF
            ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml &&
            ln -nfs #{shared_path}/config/redis.yml #{current_path}/config/redis.yml &&
            ln -nfs #{shared_path}/private #{current_path}/private &&
            ln -nfs #{shared_path}/assets #{current_path}/public/assets
            EOF
          end
        end

It’s boring and it takes so much time! Westarete had the same thoughts, that’s why they created [capistrano-helpers](https://github.com/westarete/capistrano-helpers) to make deployments with capistrano easier. 

So, this is how linking with one of those helpers look like: 

        set :shared, %w{
           public/uploads
           public/downloads/huge_files
        }
As the result, 2 symlinks will be created: 

    #{release_path}/public/uploads -> #{shared_path}/public/uploads
    #{release_path}/public/downloads/huge_files -> #{shared_path}/public/downloads/huge_files

Isn’t that awesome? And there’s lots of such useful stuff.

Just take a look at [git](https://github.com/westarete/capistrano-helpers#git) helper. It sets git as code management software, keeps local repo on server and fetch from it. Which is much faster than cloning from github every time.

Or campfire extension. It drops a message with branch name, username, application etc. to campfire chat, notifying that deployment is finished. 

Last one we found so useful, that created PR to notify that deployment is started.

And that’re just a couple of examples ;)

If you want to know more, you can dig directly into each helper code :

https://github.com/westarete/capistrano-helpers/tree/master/lib/capistrano-helpers 

## [cap db:pull](http://blog.jerodsanto.net/2011/06/cap-db-pull/)
If there's one thing I've learned from **Heroku**, it's that grabbing a snapshot of your production database is incredibly handy for troubleshooting.

`heroku db:pull` is so rad that I wanted to have it on other projects not hosted on their platform, so I wrote a **Capistrano** task which accomplishes the same goal.

This task is **PostgreSQL** specific, but can be easily adapted to work with other datastores. Just replace the `pg_dump` and `pg_restore` related commands with ones that your datastore provides. The process is still the same.

    namespace :db do
      desc "Snapshots production db and dumps into local development db"
      task :pull, roles: :db, only: { primary: true } do
        # adjust prod_config to point to your database.yml
        prod_config = capture "cat #{shared_path}/config/database.yml"
    
        prod = YAML::load(prod_config)["production"]
        dev  = YAML::load_file("config/database.yml")["development"]
        dump = "/tmp/#{Time.now.to_i}-#{application}.psql"
    
        run %{pg_dump -x -Fc #{prod["database"]} -f #{dump}}
        get dump, dump
        run "rm #{dump}"
    
        system %{dropdb #{dev["database"]}}
        system %{createdb #{dev["database"]} -O #{dev["username"]}}
        system %{pg_restore -O -U #{dev["username"]} -d #{dev["database"]} #{dump}}
        system "rm #{dump}"
      end
    end

The reason that I'm dropping and recreating the development database before running the restore is that I could not find an easier way to restore a database that has a different user and name in production than it does in development. If you know of a better way to accomplish, please let me know.

Now just run `cap db:pull` and you're on your way!

## Capify - public key deployment

I’ve been playing with Capistrano a lot lately and loving it. Here is an example of how easy it is to write tasks and use them on multiple remote servers.

This task installs your SSH public key on the remote machine to allow key-based authentication:

    set :key_file do
      Capistrano::CLI.ui.ask "enter public key to push: "
    end
    
    desc "configures key-based SSH administration"
    task :push_key, :roles  => :all do
      key_location = File.expand_path(key_file)
      unless File.exist?(key_location) and key_file.match(/\.pub$/)
        puts "Couldn't locate public key. Try again"
        exit
      end
      key_file_name = File.basename(key_location)
      upload key_location, "/tmp/#{key_file_name}"
      run "if [ ! -e ~/.ssh ];then mkdir ~/.ssh; fi"
      run "cat /tmp/#{key_file_name} >> ~/.ssh/authorized_keys"
      run "rm /tmp/#{key_file_name}"
      run "chmod 600 ~/.ssh/authorized_keys"
    end
Silky smooth.

## Let Capistrano Compile Ruby 1.9 For You

A Capistrano task to install Ruby 1.9.1 to `/opt/ruby-1.9.1` on Debian:

    APTGET = "apt-get install -qqy"
    RUBY19 = "ruby-1.9.1-p129"
    SRC    = "/usr/local/src"
    WGET   = "wget -q"
    
    namespace :ruby do
    
      desc 'download and compile Ruby 1.9'
      task :install_19 do
        deps    = %w'zlib1g-dev libopenssl-ruby1.9'
        version = RUBY19.gsub(/-p\d+$/,"") # remove patch level
        run "#{APTGET} #{deps.join(' ')}"
        cmd = [
          "cd #{SRC}",
          "#{WGET} ftp://ftp.ruby-lang.org/pub/ruby/1.9/#{RUBY19}.tar.gz",
          "tar zxvf #{RUBY19}.tar.gz",
          "cd #{RUBY19}",
          "./configure --prefix=/opt/#{version} --enable-shared",
          "make",
          "make install"
          ].join(" && ")
          run cmd
      end
    
    end

With this task, you can quickly upgrade all your Debian machines to Ruby 1.9.1 without having to go through the process each time. Just:

    cap ruby:install_19

## How do I run a rake task from Capistrano?

    run("cd #{deploy_to}/current && /usr/bin/env rake `<task_name>` RAILS_ENV=production")`

The RAILS_ENV=production was a gotcha -- I didn't think of it at first and couldn't figure out why the task wasn't doing anything.

A minor improvement: if you replace the semicolon with && then the second statement (running the rake task) will not run if the first statement (changing the directory) fails. 

This won't work if you are deploying to multiple servers. It will run the rake task multiple times. – Mark Redding Jun 3 '11 at 20:36

one should really respect capistrano's rake setting "cd #{deploy_to}/current && #{rake} <task_name> RAILS_ENV=production" – kares Jun 14 '11 at 11:13

in your \config\deploy.rb, add outside any task or namespace:

    namespace :rake do  
      desc "Run a task on a remote server."  
      # run like: cap staging rake:invoke task=a_certain_task  
      task :invoke do  
        run("cd #{deploy_to}/current; /usr/bin/env rake #{ENV['task']} RAILS_ENV=#{rails_env}")  
      end  
    end

Then, from /rails_root/, you can run:

    cap staging rake:invoke task=rebuild_table_abc

better to use /usr/bin/env rake so rvm setups will pick up the correct rake

#### Use Capistrano-style rake invocations

There's a common way that'll "just work" with require 'bundler/capistrano' and other extensions that modify rake. This will also work with pre-production environments if you're using multistage. The gist? Use config vars if you can.

    desc "Run the super-awesome rake task"
    task :super_awesome do
      rake = fetch(:rake, 'rake')
      rails_env = fetch(:rails_env, 'production')
    
      run "cd '#{current_path}' && #{rake} super_awesome RAILS_ENV=#{rails_env}"
    end

This is the nicest solution, uses the capistrano values where available

I have no idea how capistrano works, but just for the record -- this is the syntax to invoke a rake task from Ruby:

    Rake::Task["task:name"].invoke

This will invoke the rake task on the machine capistrano is invoke, not the target machine.

## Capistrano is not just for deployment

I'm appreciating Capistrano more and more. It has such an elegant and powerful API, and you can use it for pretty much any commands you need to execute on one or more of your servers. Here is a simple example. For the development of this weblog I found myself quite often wanting to copy the production data to my development server. Of course at first I was doing this on the command line. The next natural step would have been to write a bash script, but these days I tend to write most of my scripts in Ruby. Rather than stick a small Ruby script under the Rails script directory I'm starting to create Rake tasks under lib/tasks though. One advantage of having scripts as Rake tasks is that you can cagalog them nicely with "rake --tasks". Here is the Rake task:

    namespace :db do
      desc "Update the development database with a fresh dump of production"
      task :update_dev do
        host = "deploy@marklunds.com"
        db = "marklunds_production"
        system("ssh #{host} \"mysqldump -u root --set-charset #{db} > /tmp/#{db}.dmp\"")
        system("scp #{host}:/tmp/#{db}.dmp ~/tmp")
        system("mysql -u root marklunds_development > ~/tmp/#{db}.dmp")
      end
    end

Looking at this code I realized it needed information in the Capistrano `config/deploy.rb` file, such as the domain of the production server. Also, what the task really does it execute some commands on a remote server, and that's exactly what Capistrano is built for. So I moved the task over to deploy.rb:

    require File.dirname(__FILE__) + '/../config/environment'
    
    ...the usual deploy.rb stuff here...
    
    desc "Copy production database to development database"
    task :update_dev_db, :roles => :db do
      prod_db = ::ActiveRecord::Base.configurations['production']['database']
      dev_db = ::ActiveRecord::Base.configurations['development']['database']
      run <<-CMD
        mysqldump -u root --set-charset #{prod_db} > /tmp/#{prod_db}.dmp
      CMD
      system("scp #{user}@#{domain}:/tmp/#{prod_db}.dmp ~/tmp")
      system("mysql -u root #{dev_db} < ~/tmp/#{prod_db}.dmp")
    end

It seems a bit unclean that I have to source the whole Rails environment from Capistrano and it increases the startup time a bit. The reason I do that is to get the database names from ActiveRecord instead of hard coding them. Notice the flexibility of Capistrano tasks - executing local commands is just as easy as executing remote ones.

## Capistrano Rails Deploy without SVN or Git
I needed this post when I was just starting on Rails and didn’t know how to set-up SVN and/or Git. I used Blue Box Group Rails Shared Hosting and the really-easy-to-deploy with Capistrano.
It’s pretty easy and I will go through it step-by-step.

1. If you don’t have Capistrano installed go ahead and install it. Using Terminal, copy and paste:

        gem install capistrano

2. Tell Capistrano You will Deploy with it in Terminal

        $ cd your_apps_folder
        $ capify .
        [add] writing ‘./Capfile’
        [add] writing ‘./config/deploy.rb’
        [done] capified!

3. Configure deploy.rb
Just copy and paste this special deploy.rb that just uses your local folder on your computer, no need for Subversion (SVN) or Git:

        # Your Applications “Name”
        set :application, “Application Name”
        # The URL to your applications repository
        set :repository,  “.”
        set :scm, :none
        set :deploy_via, :copy
        # Require subversion to do an export instead of a checkout.
        set :checkout, ‘export’
        # The user you are using to deploy with (This user should have SSH access to your server)
        set :user, “Your SSH User”
        # We want to deploy everything under your user, and we don’t want to use sudo
        set :use_sudo, false
        # Where to deploy your application to.
        set :deploy_to, “/domains/Your Domain/”
        # ——————————– Server Definitions ——————————–
        # Define the hostname of your server. If you have multiple servers for multiple purposes, we can define those below as well.
        set :server_name, “sh01.blueboxgrid.com”
        # We’re assuming you’re using a single server for your site, but if you have a seperate asset server or database server, you can specify that here.
        role :app, server_name
        role :web, server_name
        role :db, server_name, :primary => true
        # ——————————– Final Config ——————————–
        # This configuration option is helpful when using svn+ssh but doesn’t hurt anything to leave it enabled always.
        default_run_options[:pty] = true
        namespace :deploy do
        task :restart do
        run “touch #{deploy_to}current/tmp/restart.txt”
        end
        task :start do
        run “cd #{deploy_to} && ln -s current/public public_html”
        run “touch #{deploy_to}current/tmp/restart.txt”
        end
        task :symlink do
        run “cd #{deploy_to} && rm current ; ln -s releases/#{release_name} current”
        run <<-CMD
        rm -rf #{latest_release}/log /home/#{user}/#{latest_release}/public/system #{latest_release}/tmp/pids &&
        ln -s /home/#{user}#{shared_path}/log /home/#{user}#{latest_release}/log &&
        ln -s /home/#{user}#{shared_path}/system /home/#{user}#{latest_release}/public/system &&
        ln -s /home/#{user}#{shared_path}/pids /home/#{user}#{latest_release}/tmp/pids
        CMD
        end
        task :stop do
        run “rm #{deploy_to}public_html”
        end
        namespace :web do
        task :disable do
        run “cd #{deploy_to} && rm public_html && ln -s static_site public_html”
        end
        task :enable do
        run “cd #{deploy_to} && rm public_html && ln -s current/public public_html”
        end
        end
        end
        task :after_setup do
        run “rm -rf #{deploy_to}public_html”
        run “mkdir #{deploy_to}static_site”
        end

4. Setup the Server

        $ cap deploy:setup
5. Do your Deploy

        $cap deploy:cold

6. (optional). If this was your first deploy you may have to setup a symlink to public_html if using Blue Box Group Shared Hosting, all you have you have to do is the following after a successful deploy in step 5:
 
        $ cap deploy:web:enable
Theoretically after that you should be able to just deploy with:

        $ cap deploy:migrations
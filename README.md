Newsletter
==========
Put some boilerplate here

Requirements
------------

* Rails 3.2.x
* Ruby 1.9.3-x
* [Bundler](http://bundler.io)

Optional Dependencies
---------------------
* [RVM](http://rvm.io) - How we control our ruby environment(mainly concerns development)


Installation
------------
* using bundler, edit your Gemfile.. add a one of the following lines:

      gem 'mail_manager', '~>3' # this points to the latest rails stable 3.2.x version
      # OR 
      gem 'mail_manager', git: 'https://github.com/LoneStarInternet/mail_manager.git', branch: 'rails3.2.x' # for the bleeding edge rails 3.2.x version

* then run bundle install:

      bundle install

* generate and configure the newsletter settings file at config/newsletter.yml: (replace table prefix with something... or nothing if you don't want to scope it)  

      rake newsletter:default_app_config[table_prefix]

* generate migrations  

      rake newsletter:import_migrations

* migrate the database

      rake db:migrate


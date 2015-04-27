Newsletter
==========
Put some boilerplate here

Requirements
------------

* Rails 3.2.x (currently tested against rails 3.2.21)
* Ruby 2.1.5 (currently tested against 2.1.5, we have also tested against 1.9.3 - but it is no longer supported by ruby devs)
* [Bundler](http://bundler.io)

Optional Dependencies
---------------------
* [RVM](http://rvm.io) - How we control our ruby environment(mainly concerns development)
* currently we use github/git for our repository

Installation
------------
* using bundler, edit your Gemfile.. add a one of the following lines:
```ruby
      gem 'newsletter', '~>3' # this points to the latest rails stable 3.2.x version
      # OR
      gem 'newsletter', git: 'https://github.com/LoneStarInternet/newsletter.git', branch: 'rails3.2.x' # for the bleeding edge rails 3.2.x version
```
* then run bundle install:
```
      bundle install
```
* generate and configure the newsletter settings file at config/newsletter.yml: (replace table prefix with something... or nothing if you don't want to scope it)
```
      rake newsletter:default_app_config[table_prefix]
```
* generate migrations
```
      rake newsletter:import_migrations
```
* migrate the database
```
      rake db:migrate
```

Securing your App
-----------------
We implemented [CanCan](https://github.com/CanCanCommunity/cancancan). If you'd like to secure your actions to certain users and don't currently have any authorization in your app, you can follow the following steps if you want an easy config.. or you could make it more finely grained.. currently its all or nothing:
[See the wiki](https://github.com/LoneStarInternet/newsletter/wiki/Securing-your-app)

Development
-----------
If you wish to contribute, you should follow these instructions to get up and running:
[See the wiki](https://github.com/LoneStarInternet/newsletter/wiki/Contributing)

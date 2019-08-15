Newsletter
==========
Email newsletter templating and management system which allows a designer to develop templates, areas, and elements that are email-friendly and allows a user to create newsletters without html/css knowledge utilizing a wysiwyg interface.
The newsletter design and areas define what elements exist and where they can be placed in a layout.
Elements are sortable/draggable within an area. There is an archive page and newsletters can be published or hidden from this view as well as sorted.
Also available as a stand alone application called [iReach](https://github.com/LoneStarInternet/iReach/releases) including mailing list and contact management, double opt-in mailing list sign up, a mailer, bounce processing, and user access management. There is also the i_reach gem that ties mail_manager and newsletter together into one gem.

If the Mailing List Manager is also installed, published newsletters will be available as mailable objects when creating a mailing. Currently only an html design can be defined, and a plain text version is available by converting the html of the newsletter.

Online Documentation
--------------------
* [Homepage](http://ireachnews.com)
* [Github Wiki](https://github.com/LoneStarInternet/newsletter/wiki)
* [Changelog](http://www.ireachnews.com/index.html#changelog)

Requirements
------------

* Rails 3.2.x (currently tested against rails 3.2.25)
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

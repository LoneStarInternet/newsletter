require 'rake'
ENV["Rails.env"] ||= "development"
require "#{Rails.root}/config/environment"

namespace :newsletter do 
  desc "Upgrade tasks"
  task :upgrade do
    Rake::Task['newsletter:import_migrations'].invoke
    Rake::Task['db:migrate'].invoke
  end
  desc "Import Example Newsletter Design"
  task :import_example_design, :design_name do |t,args|    
    Rails.logger.warn "Importing Example Newsletter Design with name: #{args.design_name}"
    Newsletter::Design.import(
      File.join(Newsletter::PLUGIN_ROOT,'designs','exports','example-export.yaml'), 
      args.design_name
    )
  end
  desc "Add defaults to config/newsletter.yml"
  task :default_app_config, :table_prefix do |t,args|
    Rails.logger.warn "Adding defaults to config/newsletter.yml"
    begin
      app_config = YAML.load_file('config/newsletter.yml')
    rescue => e
      app_config = Hash.new
    end
    File.open('config/newsletter.yml','w') do |file|
      file.write <<EOT
# this file is used to configure the newsletter gem
# it works like an older gem called AppConfig
# all environments start with settings from the 'common' section
# and are overridden by the section that matches the environment's name
# also .. if you create a 'config/newsletter.local.yml' it will override
# what is in 'config/newsletter.yml' such that you can keep a  version 
# for local settings and not overwrite one that you include in your source control
# also ... these files allow the use of erb syntax to set variables with ruby thus
# allowing ENV variables and such to be used
# here are the valid settings and what they are for:
# site_url: used in various places to get the url of the site (such as in mailings templates)
# site_path: used in various places to get the url of the site (such as in mailings templates)
# layout: layout used for newsletter administration pages
# archive_layout: layout used for public facing pages like the newsletter archive
# designs_require_authentication: whether you need to log in to manage designs(recommended)
# design_authorized_roles: array of role names that can manage designs
# newsletters_require_authentication: whether you need to log in to manage newsletters(everyone can currently see them.. devise your own abilities if you want to require login for these)
# newsletter_authorized_roles: array of role names that can manage newsletters
# roles_method: the method which gives a list of role names for the 'current_user' of the app, if it answers with an array of names as strings with 'roles' or a string with 'role' this doesn't have to be set
# designs_path: path from your rails root where design templates are saved
# asset_path: where your newsletter assets are saved(images, pdfs, etc for newsletter instances-uploaded with carrier_wave)
# table_prefix: prefix your newsletter tables to avoid collisions
#
#
# The following 2 might be deprecated soon
# show_title: can be used in templates/layouts to see whether you should show a title
# use_show_for_resources: whether to have links to "show" actions - we don't use them really in this app..
# and the 'show' actions aren't really currently supported
EOT
      file.write YAML.dump({
        'common' => {
          'site_url' => 'http://example.com',
          'layout' => 'newsletter/application',
          'archive_layout' => 'layout',
          'use_show_for_resources' => false,
          'show_title' => true,
          'designs_require_authentication' => false,
          'design_authorized_roles' => [],
          'newsletters_require_authentication' => false,
          'newsletter_authorized_roles' => [],
          'roles_method' => '',
          'designs_path' => "<%= File.join(Rails.root,'designs') %>",
          'asset_path' =>  'newsletter_assets',
          'site_path' =>  '/admin',
          'table_prefix' =>  args.table_prefix
        },
        'development' => {
          'site_url' => 'http://example.dev',
        },
        'test' => {
          'site_url' => 'http://example.lvh.me',
        }
      }.deep_merge(app_config))
    end
  end

  desc "Import newsletter migrations"
  task :import_migrations do
    Rails.logger.warn "Checking for newsletter migrations..." 
    seconds_offset = 1
    migrations_dir = ::Newsletter::PLUGIN_ROOT+'/db/migrate'
    Dir.entries(migrations_dir).
      select{|filename| filename =~ /^\d+.*rb$/}.sort.each do |filename|
      migration_name = filename.gsub(/^\d+/,'')
      if Dir.entries('db/migrate').detect{|file| file =~ /^\d+#{migration_name}$/}
        puts "Migrations already exist for #{migration_name}"
      else        
        Rails.logger.info "Importing  Migration: #{migration_name}"
        File.open("db/migrate/#{seconds_offset.seconds.from_now.strftime("%Y%m%d%H%M%S")}#{migration_name}",'w') do |file|
          file.write File.readlines("#{migrations_dir}/#{filename}").join
        end
        seconds_offset += 1
      end
    end
  end
end

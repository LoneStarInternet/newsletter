#require 'rake'
#ENV["RAILS_ENV"] ||= "development"
#require "#{RAILS_ROOT}/config/environment"
#
#namespace :newsletter do 
#  desc "Create Newsletter LSI Auth Menus"
#  task :create_auth_menus do
#    Rails.logger.warn "Creating Newsletter LSI Auth Menus"
#    parent_menu = 'Newsletter'
#    AdminMenu.create_or_find(
#      :description=>'Newsletter',
#      :path=>'admin/newsletter/newsletters',
#      :admin_menu_id=>nil,
#      :menu_order=>1,
#      :is_visible=>1,
#      :auth_all=>1)
#    AdminMenu.create_or_find(
#      :description=>'Newsletters',
#      :path=>'admin/newsletter/newsletters',
#      :admin_menu_id=>AdminMenu.find_by_description('Newsletter').id,
#      :menu_order=>1,
#      :is_visible=>1,
#      :auth_all=>1)
#    AdminMenu.create_or_find(
#      :description=>'Newsletter General Auth',
#      :path=>'admin/newsletter',
#      :admin_menu_id=>nil,
#      :menu_order=>0,
#      :is_visible=>0,
#      :auth_all=>1)
#    AdminMenu.create!(
#      :description=>'Designs',
#      :path=>'admin/newsletter/designs',
#      :admin_menu_id=>AdminMenu.find_by_description('Newsletter').id,
#      :menu_order=>1,
#      :is_visible=>1,
#      :auth_all=>1)
#  end
#
#  desc "Import Example Newsletter Design"
#  task :import_example_design do     
#    Rails.logger.warn "Importing Example Newsletter Design"
#    Newsletter::Design.import(
#      'vendor/plugins/newsletter/newsletters/exports/example-export.yaml')
#  end
#
#  desc "Add newsletter defaults to config/config.yml"
#  task :default_app_config, :table_prefix do |t,args|
#    Rails.logger.warn "Adding newsletter defaults to config/config.yml"
#    begin
#      app_config = YAML.load_file('config/config.yml')
#    rescue => e
#      app_config = Hash.new
#    end
#    File.open('config/config.yml','w') do |file|
#      file.write YAML.dump({
#        'common' => {
#          'newsletters_path' => '<%= "#{RAILS_ROOT}/newsletters" %>',
#          'newsletter_asset_path' =>  'public/newsletter_assets',
#          'newsletter_path_prefix' =>  '/admin',
#          'newsletter_table_prefix' =>  args.table_prefix
#      }}.deep_merge(app_config))
#    end
#  end
#  desc "Import newsletter migrations"
#  task :import_migrations do
#    Rails.logger.warn "Checking for newsletter migrations..." 
#    seconds_offset = 1
#    migrations_dir = ::NewsletterPlugin::PLUGIN_ROOT+'/db/migrate'
#    Dir.entries(migrations_dir).
#      select{|filename| filename =~ /^\d+.*rb$/}.sort.each do |filename|
#      migration_name = filename.gsub(/^\d+/,'')
#      if Dir.entries('db/migrate').detect{|file| file =~ /^\d+#{migration_name}$/}
#        puts "Migrations already exist for #{migration_name}"
#      else        
#        Rails.logger.info "Importing  Migration: #{migration_name}"
#        File.open("db/migrate/#{seconds_offset.seconds.from_now.strftime("%Y%m%d%H%M%S")}#{migration_name}",'w') do |file|
#          file.write File.readlines("#{migrations_dir}/#{filename}").join
#        end
#        seconds_offset += 1
#      end
#    end
#  end
#end

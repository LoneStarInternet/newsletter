require 'rake'
ENV["Rails.env"] ||= "development"
require "#{Rails.root}/config/environment"

namespace :newsletter do 
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
      file.write YAML.dump({
        'common' => {
          'site_url' => 'http://example.com',
          'layout' => 'newsletter/application',
          'archive_layout' => 'layout',
          'use_show_for_resources' => false,
          'designs_require_authentication' => false,
          'design_authorized_roles' => [],
          'newsletters_require_authentication' => false,
          'newsletter_authorized_roles' => [],
          'roles_method' => '',
          'designs_path' => "<%= File.join(Rails.root,'designs') %>",
          'asset_path' =>  'newsletter_assets',
          'path_prefix' =>  '/admin',
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

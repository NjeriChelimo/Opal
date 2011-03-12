app_name = "Opal"
namespace app_name.downcase.to_sym do

  desc "Install #{app_name} - Database, Default Data, and optional Example Data"
  task :install => :environment do
    ENV["PROMPTS"] ||= "TRUE"    
    ENV["RAILS_ENV"] ||= "production"    
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke 
  end

  desc 'Uninstall #{app_name}'
  task :uninstall => :environment do
    ENV["RAILS_ENV"] ||= "production"
    ENV["PROMPTS"] ||= "TRUE"    
    ENV['VERSION']= '0'
    Rake::Task['db:migrate'].invoke
  end

  desc "Update #{app_name}"
  task :install => :environment do
    ENV["PROMPTS"] ||= "TRUE"    
    ENV["RAILS_ENV"] ||= "production"    
    Rake::Task["db:migrate"].invoke
  end

  desc "Reset #{app_name}, To bypass prompts, type: rake opal:reset PROMPTS=FALSE"
  task :reset => :environment do |task, args|
    # Set ENV Defaults
    ENV["PROMPTS"] ||= "TRUE"    
    ENV["RAILS_ENV"] ||= "production"    
    Rake::Task["#{app_name.downcase}:uninstall"].invoke
    ENV.delete 'VERSION' # clear version 
    Rake::Task['db:migrate'].reenable
    Rake::Task["#{app_name.downcase}:install"].invoke    
  end

  namespace :db do
    desc "Backup Database"
    task :backup => :environment do
      ENV["RAILS_ENV"] ||= "production"      
      db = YAML::load(File.open(File.join(Rails.root.to_s,"config", "database.yml")))
      db_config = db[RAILS_ENV]      
      backup_path = File.join(Rails.root.to_s, "backup", Time.now.strftime("%Y%m%d_%H%M%S" + ".sql"))
      FileUtils.mkdir_p(File.dirname(backup_path)) if !File.exists?(File.dirname(backup_path))
      db_config["host"] ||= "localhost"
      
      if db_config["adapter"] == "mysql"
        command = "mysqldump -u #{db_config["username"]} -p'#{db_config["password"]}' #{db_config["database"]} -h #{db_config["host"]} # > #{backup_path}"
      end
      if defined?(command) && !command.nil?
        system(command)
      else
        "No Command specified."
      end
      puts I18n.t("label.item_backup_success", :item => I18n.t("name")) + "(#{backup_path})"
    end    
  end
end




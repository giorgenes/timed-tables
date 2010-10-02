require 'rails/generators'
require 'rails/generators/migration'

class TimedTablesGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end
   
	def install_migration_files
		copy_file 'db/migrate/20100510210543_create_timed_tables.rb'
		copy_file 'db/migrate/20100510233541_create_day_row_totals.rb'
	end
end

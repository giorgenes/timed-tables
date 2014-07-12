require 'timed_tables'
require 'rails'
require 'action_controller'

module TimedTables 
  class Engine < Rails::Engine

    # Config defaults
    config.widget_factory_name = "default factory name"
    config.mount_at = '/'
    
    # Load rake tasks
    rake_tasks do
      load File.join(File.dirname(__FILE__), 'rails/railties/tasks.rake')
    end

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
    
    # Check the gem config
    initializer "check config" do |app|

      # make sure mount_at ends with trailing slash
      config.mount_at += '/'  unless config.mount_at.last == '/'
    end
  end
end

require 'bundler/gem_tasks'
require 'cucumber/rake/task'
require 'yard'

gem_name = 'middleman-pagegroups'

###############################################################################
# :default
#   Define the default task.
###############################################################################
task :default => :test


###############################################################################
# :install
#   (inherited behavior)
###############################################################################

Cucumber::Rake::Task.new(:test, 'Features that must pass') do |task|
  task.cucumber_opts = '--require features --color --tags ~@wip --strict --format QuietFormatter'
end


YARD::Rake::YardocTask.new(:yard) do |task|
  task.stats_options = ['--list-undoc']
end


desc 'Make separate documents for documentation_project.'
task :partials do

  sections = [
      { :file => '_yard_helpers.erb',          :group => 'Helpers',  },
      { :file => '_yard_helpers_css.erb',      :group => 'CSS Class Helpers',  },
      { :file => '_yard_helpers_extended.erb', :group => 'Extended Helpers' },
      { :file => '_yard_config.erb',           :group => 'Extension Configuration' },
      { :file => '_yard_resources.erb',        :group => 'Resource Extensions',  },
  ]

  sections.each do |s|
    command = "yardoc --query 'o.group == \"#{s[:group]}\" || has_tag?(:author)' -o doc -t default -p #{File.join(File.dirname(__FILE__), 'yard', 'template-partials')}"
    puts command
    system(command)
    File.rename('doc/index.html', "doc/#{s[:file]}")
  end

end

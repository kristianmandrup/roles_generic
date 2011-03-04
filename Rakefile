begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "roles_generic"
    gem.summary = %Q{Generic role strategies sharing the same API}
    gem.description = %Q{Generic role strategies sharing the same API. Easy to insert in any model}
    gem.email = "kmandrup@gmail.com"
    gem.homepage = "http://github.com/kristianmandrup/roles_generic"
    gem.authors = ["Kristian Mandrup"]
    gem.rubygems_version = '1.5.0'
        
    # See Gemfile for regular dependencies
    gem.add_development_dependency "rspec",             '>= 2.4.1'
    gem.add_development_dependency "generator-spec",    '>= 0.7.3'

    # COMMENTED OUT TO AVOID DUPLICATION WITH GEMFILE:
    #   https://github.com/technicalpickles/jeweler/issues#issue/152
    gem.add_dependency 'require_all',   '~> 1.2.0'
    gem.add_dependency 'activesupport', '>= 3.0.1'
    gem.add_dependency 'sugar-high',    '~> 0.3.4'

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

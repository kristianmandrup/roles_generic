begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "roles_generic"
    gem.summary = %Q{Generic role strategies sharing the same API}
    gem.description = %Q{Generic role strategies sharing the same API. Easy to insert in any model}
    gem.email = "kmandrup@gmail.com"
    gem.homepage = "http://github.com/kristianmandrup/roles_generic"
    gem.authors = ["Kristian Mandrup"]
    gem.add_development_dependency "rspec",           ">= 2.0.1"
    gem.add_development_dependency "generator-spec",  ">= 0.7.2"

    gem.add_dependency "require_all",       "~> 1.2.0"
    gem.add_dependency "activesupport",     ">= 3.0.1"    
    gem.add_dependency 'sugar-high',        "~> 0.3.1" 
    gem.add_dependency 'rails3_artifactor', '~> 0.3.2'
    gem.add_dependency 'logging_assist',    '>= 0.1.6'

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

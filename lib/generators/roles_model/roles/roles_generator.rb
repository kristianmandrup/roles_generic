module MongoMapper 
  module Generators
    class RolesGenerator < Rails::Generators::NamedBase
      desc "Add role strategy to a model" 
      
      argument :role_strategy, :type => :string, :aliases => "-s", :default => 'role_string', :desc => "Role strategy to add"

      # TODO: Should detect ORM from file content instead!
      class_option :orm, :type => :string, :aliases => "-o", :default => nil, :desc => "ORM of model"

      class_option :roles, :type => :array, :aliases => "-r", :default => [], :desc => "Valid roles"

      hook_for :orm
            
      def self.source_root
        @source_root ||= File.expand_path("../../templates", __FILE__)
      end

      def apply_role_strategy   
        insert_into_model('user', role_strategy_statement)
      end 
      
      protected                  

      def orm
        @orm ||= options[:orm].to_s.to_sym        
      end

      def roles
        @orm ||= options[:roles].map{|r| ":#{r}" }
      end

      def match_expr
        return name.camelize if !orm

        case orm
        when :mongo_mapper
          /include MongoMapper::Document/
        when :active_record
          /ActiveRecord::Base/
        else
          raise ArgumentError, "Unrecognized orm option: #{orm}"
        end
      end

      def role_strategy_statement 
        "role_strategy #{role_strategy}"        
      end

      def roles_statement
        roles ? "roles #{roles.join(',')}" : ''
      end

      def insert_text
        %Q{include RoleModels::Generic 
          #{role_strategy_statement}
          #{roles_statement}
        }

      def role_strategy
        options[:role_strategy]                
      end
      
      def model_file(name)                          
        File.join(Rails.root, "app/models/#{name}.rb")        
      end
        
      def insert_into_model(model_name, insert_text)
        model_name = model_name.to_s
        file = File.new(model_file(model_name))
        return if (file.read =~ /#{insert_text}/) 
        gsub_file model_file(model_name), match_expr do |match|
          match << insert_text
        end
      end              
    end
  end
end
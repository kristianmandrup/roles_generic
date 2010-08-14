module RolesModel 
  module Generators
    class RolesGenerator < Rails::Generators::NamedBase
      include Rails::Generators::MigrationHelper
      
      desc "Add role strategy to a model" 
      
      class_option :strategy, :type => :string, :aliases => "-s", :default => 'role_string', 
                   :desc => "Role strategy to use (admin_flag, role_string, roles_string, role_strings, one_role, many_roles, roles_mask)"


      class_option :roles, :type => :array, :aliases => "-r", :default => [], :desc => "Valid roles"
      # TODO: Should detect ORM from file content instead!
      class_option :orm, :type => :string, :aliases => "-o", :default => nil, :desc => "ORM of model"


      # hook_for :orm
            
      def self.source_root
        @source_root ||= File.expand_path("../../templates", __FILE__)
      end

      def apply_role_strategy        
        self.class.use_orm orm if orm
        insert_into_model name do
          insertion_text
        end
      end 
      
      protected                  

      def strategy
        options[:strategy]
      end

      def orm
        @orm ||= options[:orm].to_s.to_sym        
      end

      def roles
        @roles ||= options[:roles].map{|r| ":#{r}" }
      end

      def role_strategy_statement 
        "role_strategy :#{strategy}\n"
      end

      def roles_statement
        roles ? "roles #{roles.join(',')}" : ''
      end

      def insertion_text
        %Q{  
  include RoleModels::Generic 
  #{role_strategy_statement}
  #{roles_statement}
}
      end

      def role_strategy
        options[:role_strategy]                
      end
    end
  end
end
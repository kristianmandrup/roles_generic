require 'rails3_artifactor'

module RolesGeneric 
  module Generators
    class RolesGenerator < Rails::Generators::NamedBase
      include Rails3::Assist::Artifact::Model
      
      desc "Add role strategy to a model" 
      
      class_option :strategy, :type => :string, :aliases => "-s", :default => 'role_string', 
                   :desc => "Role strategy to use (admin_flag, role_string, roles_string, role_strings, one_role, many_roles, roles_mask)"


      class_option :roles, :type => :array, :aliases => "-r", :default => [], :desc => "Valid roles"

      # hook_for :orm
            
      def self.source_root
        @source_root ||= File.expand_path("../../templates", __FILE__)
      end

      def apply_role_strategy
        insert_into_model name do
          insertion_text
        end
      end 
      
      protected                  

      def default_roles
        [:admin, :guest]        
      end

      def roles_to_add
        default_roles.concat(options[:roles]).compact.uniq
      end

      def roles
        @roles ||= roles_to_add.map{|r| ":#{r}" }
      end

      def role_strategy_statement 
        "strategy :#{strategy}\n"
      end

      def roles_statement
        roles ? "valid_roles_are #{roles.join(',')}" : ''
      end

      def insertion_text
        %Q{  
  include Roles::#{orm.to_s.camelize} 
  #{role_strategy_statement}
  #{roles_statement}
}
      end

      def strategy
        options[:strategy]                
      end
    end
  end
end
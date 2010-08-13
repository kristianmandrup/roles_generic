module MongoMapper 
  module Generators
    class RolesGenerator < Rails::Generators::NamedBase
      desc "Generate roles model for User" 
      
      argument :role_strategy, :type => :string, :aliases => "-r", :default => 'inline_role', :desc => "Create roles model for user"

      hook_for :orm
            
      def self.source_root
        @source_root ||= File.expand_path("../../templates", __FILE__)
      end

      def apply_role_strategy   
        insert_into_model('user', role_strategy_statement)
      end 
      
      protected                  

      def match_expr
        /include MongoMapper::Document/
      end

      def role_strategy_statement 
        "role_strategy #{role_strategy}"        
      end

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
require 'generator_spec_helper'
require_generator :roles_model => :roles

describe 'role strategy generator: admin_flag' do
  let(:strategy) { :admin_flag }

  describe 'ORM: none' do
    let(:orm)    { :none }
  
    use_orm :none
    helpers :model  
    
    before :each do              
      setup_generator 'roles_generator' do
        tests RolesModel::Generators::RolesGenerator
      end    
      remove_model 'user'    
    end

    after :each do
      remove_model 'user'
    end
        
    it "should configure 'admin_flag' strategy" do            
      create_model :user do
        '# content'
      end
      with_generator do |g|   
        arguments = "User --strategy #{strategy} --roles admin user --orm #{orm}"
        puts "arguments: #{arguments}"
        g.run_generator arguments.args
        g.should generate_model :user do |clazz|
          clazz.should include_module 'Roles::Generic'
          clazz.should have_call :valid_roles_are, :args => ':admin, :user'
          clazz.should have_call :strategy, :args => ":#{strategy}"        
        end
      end
    end
  end

  describe 'ORM: active_record' do 
    let(:orm)    { :active_record }
        
    use_orm :active_record
    helpers :model  
    
    before :each do              
      setup_generator 'roles_generator' do
        tests RolesModel::Generators::RolesGenerator
      end    
      remove_model 'user'    
    end

    after :each do
      # remove_model 'user'
    end
        
    it "should configure 'admin_flag' strategy" do            
      create_model :user do
        '# content'
      end
      with_generator do |g|   
        arguments = "User --strategy #{strategy} --roles admin user --orm #{orm}"
        puts "arguments: #{arguments}"
        g.run_generator arguments.args
        g.should generate_model :user do |clazz|
          clazz.should include_module 'RoleModels::Generic'
          puts "clazz: #{clazz}"        
          clazz.should have_call :roles, :args => ':admin, :user'
          clazz.should have_call :role_strategy, :args => ":#{strategy}"        
        end
      end
    end
  end
end


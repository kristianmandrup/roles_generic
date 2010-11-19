require 'generator_spec_helper'
require_generator :roles_model => :roles

describe 'helper_generator' do
  let(:strategy) { 'roles_mask' }
  
  use_orm :active_record
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
        
  it "should configure 'roles_mask' strategy" do            
    create_model :user do
      '# content'
    end
    with_generator do |g|   
      arguments = "User --strategy #{strategy} --roles admin user --orm active_record"
      puts "arguments: #{arguments}"
      g.run_generator arguments.args
      g.should generate_model :user do |clazz|
        clazz.should include_module 'RoleModels::Generic'
        clazz.should have_call :valid_roles_are, :args => ':admin, :user'
        clazz.should have_call :strategy, :args => ":#{strategy}"        
      end
    end
  end
end




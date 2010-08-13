require File.expand_path(File.dirname(__FILE__) + '/../../generator_spec_helper')
require_generator :roles_model => :roles

describe 'helper_generator' do  
  before :each do              
    setup_generator 'roles_generator' do
      tests RolesModel::Generators::RolesGenerator
    end    
    remove_model 'user'
  end

  after :each do
    remove_model 'user'
  end

  STRATEGY = 'many_roles'    
  
  it "should configure '#{STRATEGY}' strategy" do            
    with_generator do |g|   
      g.run_generator "User #{STRATEGY} --roles admin user"
      g.should generate_model :user do |clazz|
        clazz.should include_module 'RoleModels::Generic'        
        clazz.should have_call :role_strategy, :args => ":#{STRATEGY}"
        clazz.should have_call :roles, :args => ':admin, :user'
      end
    end
  end
end




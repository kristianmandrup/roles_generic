require 'spec_helper'
use_roles_strategy :one_role

class User
  include Roles::Generic 
  strategy :one_role, :default

  role_class :role   
    
  attr_accessor :name

  valid_roles_are :admin, :user 
  
  def initialize name, *new_roles
    self.name = name
    self.roles = new_roles
  end 
end


describe "Generic OneRole role strategy" do
  context "default setup" do
  
    before :each do    
      @admin_user = User.new 'Admin user', :admin
      @user = User.new 'User', :user
    end

    it "should have admin user role to :admin" do
      @admin_user.role.should == :admin
      @admin_user.roles.should == [:admin]      
      @admin_user.admin?.should be_true

      @admin_user.has_role?(:user).should be_false

      @admin_user.has_role?(:admin).should be_true
      @admin_user.is?(:admin).should be_true
      @admin_user.has_roles?(:admin).should be_true
      @admin_user.has?(:admin).should be_true      
    end

    it "should have user role to :user" do
      @user.roles.should == [:user]
      @user.admin?.should be_false
      
      @user.has_role?(:user).should be_true    
      @user.has_role?(:admin).should be_false
      @user.is?(:admin).should be_false
      
      @user.has_roles?(:admin).should be_false
      @user.has?(:admin).should be_false
    end
      
    it "should set user role to :admin using roles=" do
      @user.roles = :admin      
      @user.role.should == :admin           
      @user.has_role?(:admin).should be_true      
    end
      
    it "should set user role to :admin using role=" do
      @user.roles = :admin      
      @user.role.should == :admin
      @user.has_role?(:admin).should be_true      
    end
  end
end
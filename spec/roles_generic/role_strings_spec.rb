require 'spec_helper'
use_roles_strategy :role_strings

class User
  include RoleModels::Generic 
   
  attr_accessor :name, :role_strings
   
  role_strategy :role_strings, :default

  roles :admin, :user
  
  def initialize name, *new_roles
    self.name = name
    self.roles = new_roles
  end 
end


describe "Generic RoleStrings role strategy" do
  context "default setup" do

    before :each do
      @admin_user = User.new 'Admin user', :admin
      @user = User.new 'User', :user
    end

    it "should have admin user role to :admin" do
      @admin_user.roles.first.should == :admin      
      @admin_user.admin?.should be_true

      @admin_user.has_role?(:user).should be_false

      @admin_user.has_role?(:admin).should be_true
      @admin_user.is?(:admin).should be_true
      @admin_user.has_roles?(:admin).should be_true
      @admin_user.has?(:admin).should be_true      
    end

    it "should have user role to :user" do
      @user.roles.first.should == :user
      @user.admin?.should be_false
    
      @user.has_role?(:user).should be_true    
      @user.has_role?(:admin).should be_false
      @user.is?(:admin).should be_false
      
      @user.has_roles?(:admin).should be_false
      @user.has?(:admin).should be_false
    end
    
    it "should set user role to :admin using roles=" do
      @user.roles = :admin      
      @user.roles.first.should == :admin           
      @user.has_role?(:admin).should be_true      
    end    
  end
end
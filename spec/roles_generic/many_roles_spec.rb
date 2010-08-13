require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'set'

class Role
  attr_accessor :name
  
  def self.find_role role_name    
    roles.to_a.select{|r| r.name == role_name}.first
  end  

  def self.find_roles *role_names
    result = Set.new
    role_names.flatten.each do |role_name| 
      found_role = find_role(role_name)
      result << found_role if found_role
    end
    result
  end

  class << self
    attr_accessor :roles
  end    
  
  def initialize name
    @name = name
    self.class.roles ||= Set.new
    self.class.roles << self
  end  
end

class User
  include RoleModels::Generic 
  role_strategy :many_roles, :default

  role_class :role   
    
  attr_accessor :name, :many_roles

  roles :admin, :user 
  
  def initialize name, *new_roles
    self.name = name
    self.roles = new_roles
  end 
end


describe "Generic ManyRoles role strategy" do
  context "default setup" do

    before :each do          
      Role.new :user
      Role.new :admin    
    
      @admin_user = User.new 'Admin user', :admin
      @user = User.new 'User', :user
    end

    it "should have admin user role to :admin" do
      @admin_user.roles_list.first.should == :admin      
      @admin_user.admin?.should be_true

      @admin_user.has_role?(:user).should be_false

      @admin_user.has_role?(:admin).should be_true
      @admin_user.is?(:admin).should be_true
      @admin_user.has_roles?(:admin).should be_true
      @admin_user.has?(:admin).should be_true      
    end

    it "should have user role to :user" do
      @user.roles_list.first.should == :user
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
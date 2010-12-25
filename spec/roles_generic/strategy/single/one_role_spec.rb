require 'spec_helper'

class User
  include Roles::Generic 
  strategy :one_role, :default

  attr_accessor :name

  valid_roles_are :admin, :user, :guest 
  
  def initialize name, *new_roles
    self.name = name
    self.roles = new_roles
  end 
end


describe "Roles Generic: :one_role strategy" do
  require "roles_generic/rspec/test_it"
  
  it "should return all registered roles" do
    Role.all.should include(Role.roles.to_a[0])
    Role.names.should include( :admin, :user )      
  end    
end
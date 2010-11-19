require 'spec_helper'
use_roles_strategy :many_roles

class User
  include Roles::Generic 
  strategy :many_roles, :default

  role_class :role       
  attr_accessor :name

  valid_roles_are :admin, :user, :guest 
  
  def initialize name, *new_roles
    self.name = name
    self.roles = new_roles
  end 
end  

describe "Roles Generic: :many_roles strategy" do
  require "roles_generic/rspec/api/full"
  
  it "should return all registered roles" do
    Role.all.should include(Role.roles.to_a[0])
    Role.names.should include( :admin, :user )      
  end  
end    

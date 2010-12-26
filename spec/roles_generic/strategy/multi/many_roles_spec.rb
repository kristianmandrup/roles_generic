require 'spec_helper'

class User
  include Roles::Generic 

  attr_accessor :name

  strategy :many_roles
  valid_roles_are :admin, :user, :guest 
  
  def initialize name, *new_roles
    self.name = name
    self.roles = new_roles
  end 
end  

describe "Roles Generic: :many_roles strategy" do
  require "roles_generic/rspec/test_it"
  
  it "should return all registered roles" do
    Role.all.should include(Role.roles.to_a[0])
    Role.names.should include( :admin, :user )      
  end  
end    

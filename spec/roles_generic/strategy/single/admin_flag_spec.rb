require 'spec_helper'
class User
  include Roles::Generic 

  attr_accessor :name 
  
  strategy :admin_flag
  valid_roles_are :admin, :user, :guest
  
  def initialize name, *new_roles
    self.name = name
    self.roles = new_roles
  end 
end

describe "Roles Generic: :admin_flag strategy" do
  require "roles_generic/rspec/test_it"
end
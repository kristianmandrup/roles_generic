require 'spec_helper'
use_roles_strategy :roles_string

class User
  include Roles::Generic
   
  attr_accessor :name
   
  strategy :roles_string, :default
  valid_roles_are :admin, :user, :guest
  
  def initialize name, *new_roles
    self.name = name
    self.roles = new_roles
  end 
end


describe "Roles Generic: :roles_string strategy" do
  require "roles_generic/rspec/test_it"
end
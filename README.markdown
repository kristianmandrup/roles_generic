# Roles Model base

Generic role strategies that share the same API and are easy to insert in any existing User model. 

*Update: Now with a Rails 3 generator to instantly populate your user model of choice with a role strategy!*

# Install

<code>gem install roles_generic</code>

# Usage

The library comes with the following role models built-in:

* admin_flag (Boolean flag - 'admin' or not)
* role_string (String)
* roles_string (Comma separated String - note: no role name must have a comma in its name!)
* role_strings (Set of Strings)
* roles_mask (Integer mask)
* one_role (relation to a Role model instance)
* many_roles(Set of Role relationships)

Note: The following examples use RSpec to demonstrate usage scenarios.

## Example : admin_flag

Creates and uses a binary field 'admin_flag', which when true signals that this user is an administrator and otherwise a normal user.

<pre>
  class User
    include RoleModels::Generic 

    attr_accessor :name, :admin_flag 

    role_strategy :admin_flag, :default

    roles :admin, :user

    def initialize name, *new_roles
      self.name = name
      self.roles = new_roles
    end 
  end
</pre>

## Example: Using an ORM

Data Mapper with persistent attributes :name and :admin_flag

<pre>
  class User
    include RoleModels::Generic 
    include DataMapper::Resource

    property :name, Boolean
    property :admin_flag, Boolean

    role_strategy :admin_flag, :default

    roles :admin, :user

    def initialize name, *new_roles
      self.name = name
      self.roles = new_roles
    end 
  end
</pre>


## Example : role_string

Creates and uses a single role name, a string

<pre>
  class User
    include RoleModels::Generic 

    attr_accessor :name, :role_string

    role_strategy :role_string, :default

    roles :admin, :user

    def initialize name, *new_roles
      self.name = name
      self.roles = new_roles
    end 
  end
</pre>

## Example : roles_string

Creates and uses single comma separated String of role names

<pre>
  class User
    include RoleModels::Generic 

    attr_accessor :name, :roles_string

    role_strategy :roles_string, :default

    roles :admin, :user

    def initialize name, *new_roles
      self.name = name
      self.roles = new_roles
    end 
  end
</pre>

## Example : role_strings

Creates and uses an Set of role names as strings

<pre>
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
</pre>

## Example : roles_mask

Creates and uses an Integer field where each on bit signifies a role

<pre>
  class User
    include RoleModels::Generic 

    attr_accessor :name, :roles_mask

    role_strategy :roles_mask, :default

    roles :admin, :user

    def initialize name, *new_roles
      self.name = name
      self.roles = new_roles
    end 
  end
</pre>
    
## Example : one_role

Creates and uses a single relation to a Role model for each user

<pre>
  class Role
    attr_accessor :name

    def self.find_role role_name    
      roles.to_a.select{|r| r.name == role_name}.first
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
    role_strategy :one_role, :default

    role_class :role   

    attr_accessor :name, :one_role

    roles :admin, :user 

    def initialize name, *new_roles
      self.name = name
      self.roles = new_roles
    end 
  end
</pre>

## Example : many_roles

Creates and uses a single relation to a Role model for each user

<pre>
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
</pre>

## Usage of API

<pre>
  before :each do
    @admin_user = User.new 'Admin user', :admin
    @user = User.new 'User', :user
  end

  it "user 'Admin user' should have role :admin" do
    @admin_user.role.should == :admin
    @admin_user.roles.should == [:admin]      
    @admin_user.admin?.should be_true

    @admin_user.has_role?(:user).should be_false

    @admin_user.has_role?(:admin).should be_true
    @admin_user.is?(:admin).should be_true
    @admin_user.has_roles?(:admin).should be_true
    @admin_user.has?(:admin).should be_true      
  end

  it "user 'User' should have role :user" do
    @user.roles.should == [:user]
    @user.admin?.should be_false
  
    @user.has_role?(:user).should be_true    
    @user.has_role?(:admin).should be_false
    @user.is?(:admin).should be_false
    
    @user.has_roles?(:user).should be_true
    @user.has?(:admin).should be_false
  end
  
  it "should set 'User' role to :admin using roles=" do
    @user.roles = :admin      
    @user.role.should == :admin           
    @user.has_role?(:admin).should be_true      
  end  
</pre>  

## Future (TODO)

The following in planned to be completed before the end of August 2010.

### Clean up (DRY)

DRY up the role strategy code a lot more! There is a lot more potential for code reuse - way too much duplication now.

### Rails generator

The library will come with a Rails 3 generator that lets you populate a user model with a given role strategy 

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Kristian Mandrup. See LICENSE for details.

# Generic Role strategies

Generic role strategies that share the same API and are easy to insert in any existing User model. 
Comes with a Rails 3 generator to instantly configure your Rails 3 app with a Role strategy of choice.

I am in the process of developing multiple *roles_xxx* gems in order to support this generic API for various popular ORMs, such as:

* Active Record (roles_ar)
* DataMapper (roles_dm_)
* Mongoid (roles_mongoid)
* MongoMapper (roles_mm)

Feel free to roll your own ORM extension for your favorite ORM!

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

Examples of configuring for the other strategies can be found in the wiki pages.

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

## Role API

### Instance methods

Has ALL of the given roles been assigned?
* has_roles?(*roles) - alias: is?

Has ANY (at least ONE) of the given roles been assigned?
* has_role? *roles - alias: has?

Is this a valid role? (can the role be found in list of valid roles?)
* valid_role? role

Is this user the admin user (and user has no other roles)
* admin? - short for - is?(:admin)

### Class methods

* roles - list of valid roles
* roles_attribute - get the attribute where the role is stored on the user
* roles_attribute= - set the role(s) attribute
       
## Usage of API

<pre>
  before :each do
    @admin_user = User.new 'Admin user', :admin
    @guest = User.new 'Guest', :guest
  end

  it "user 'Admin user' should have role :admin" do

    @admin_user.role.should   == :admin
    @admin_user.roles.should  == [:admin]      
    @admin_user.admin?.should be_true

    @admin_user.has_role?   (:user).should be_false

    @admin_user.has_role?   (:admin).should be_true
    @admin_user.is?         (:admin).should be_true
    @admin_user.has_roles?  (:admin).should be_true
    @admin_user.has?        (:admin).should be_true      

  end

  it "user Guest should have role :guest" do
    @guest.roles.should == [:guest]
    @guest.admin?.should be_false

    @guest.has_role?  (:guest).should be_true    
    @guest.has_role?  (:admin).should be_false
    @guest.is?        (:admin).should be_false

    @guest.has_roles? (:guest).should be_true
    @guest.has?       (:admin).should be_false
  end

  it "should set role of Guest user from :guest to :admin using roles=" do
    @guest.roles        = :admin      
    @guest.role.should == :admin           

    @guest.has_role?(:admin).should be_true      
  end
</pre>  

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

# Generic Roles

Generic Roles is a common (generic) Roles API and implementation that specific Roles implementations for various ORMs can implement.
This library also comes with a Rails 3 generator that can configure an existing user model with a Role strategy of choice.
A similar generator should always be created for specific ORM implementations 

I have developed the following *roles* gems for popular ORMs that all support the same Roles Generic API.

* Active Record - [roles_active_record](http://github.com/kristianmandrup/roles_active_record)
* DataMapper - [roles_data_mapper](http://github.com/kristianmandrup/roles_data_mapper)
* Mongoid - [roles_mongoid](http://github.com/kristianmandrup/roles_mongoid)
* MongoMapper - [roles_mongo_mapper](http://github.com/kristianmandrup/roles_mongo_mapper))

Note: some may be more mature and tested than others. Please help in the maturation process...

Also: Feel free to roll your own ORM extension for your favorite ORM!

## Install

<code>gem install roles_generic</code>

## Roles generator

A Rails 3 generator is included to update an existing model with a roles strategy and a set of valid roles

### Usage example

<code>rails g roles_generic:roles --strategy admin_flag --roles guest admin</code>  

This generator is currently (Oct. 10) experimental. Feel free to provide patches or bug reports ;)

## Usage

The library comes with the following role models built-in:

Inline roles (in User model):
* admin_flag (Boolean flag - 'admin' or not)
* role_string (String)
* roles_string (Comma separated String - note: no role name must have a comma in its name!)
* role_strings (Set of Strings)
* roles_mask (Integer mask)

Using separate Role model:
* one_role (relation to a Role model instance)
* many_roles(Set of Role relationships)

Note: The following examples use RSpec to demonstrate usage scenarios.

Examples of configuring for the other strategies can be found on the wiki pages.

## Example : admin_flag

Creates and uses a binary field 'admin_flag', which when true signals that this user is an administrator and otherwise a normal user.

<pre>
  class User
    include Roles::Generic 

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
    include Roles::Generic 
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

_Note:_ I recommend using s specific ORM roles gem such as *roles_data_mapper* instead. But this approach might be a good starting point for developing a *roles* gem for an ORM that is not supported ;)

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

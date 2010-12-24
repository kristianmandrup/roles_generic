# Generic Roles

Generic Roles is a common (generic) Roles API and implementation that specific Roles implementations for various ORMs can implement.
A Rails 3 generator is included that can configure an existing user model with a generic Role strategy of choice.

The following *roles* implementations are available. They all implement the same Roles Generic API.

Relational Database (SQL)

* Active Record   - [roles_active_record](http://github.com/kristianmandrup/roles_active_record)
* Data Mapper     - [roles_data_mapper](http://github.com/kristianmandrup/roles_data_mapper)

Mongo DB (Document store)

* Mongoid         - [roles_mongoid](http://github.com/kristianmandrup/roles_mongoid)
* Mongo Mapper    - [roles_mongo_mapper](http://github.com/kristianmandrup/roles_mongo_mapper)  

Couch DB (Document store)

* Simply Stored   - [roles_simply_stored](http://github.com/kristianmandrup/roles_simply_stored)

Note: The 'simply_stored' implementation is only partly done.

Feel free to roll your own implementation for your favorite Object Mapper!

## Install

<code>gem install roles_generic</code>

## Roles generator

A Rails 3 generator is included to update an existing User model with a roles strategy and a set of valid roles.
The Generic Roles generator doesn't work for a persistent model. In that case use a dedicated implementation for the ORM (data store) used (see above).

### Usage example

<code>rails g roles_generic:roles --strategy admin_flag --roles guest admin</code>  

## Usage

The following role models are built-in:

Inline roles (in User model):

* admin_flag (Boolean flag - 'admin' or not)
* role_string (String)
* roles_string (Comma separated String - note: no role name must have a comma in its name!)
* role_strings (Set of Strings)
* roles_mask (Integer mask)

Using separate Role model:

* one_role (single relation to a Role model instance)
* many_roles (multiple Role relationships)

Using embedded Role model (Document stores only):

* embed_one_role
* embed_many_roles  

Currently this has only been implemented for Mongoid.

## Role API

The Roles API is described in the Wiki

* [Roles-Read-API](https://github.com/kristianmandrup/roles_generic/wiki/Roles-Read-API)
* [Roles-Write-API](https://github.com/kristianmandrup/roles_generic/wiki/Roles-Write-API)

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

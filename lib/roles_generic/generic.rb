require_all File.dirname(__FILE__) + '/generic'

module Roles
  module Generic  
    def self.included(base) 
      base.extend Roles::Base       
      base.orm_name = :generic    
    end
  end
end



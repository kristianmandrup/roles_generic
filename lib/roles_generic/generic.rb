module RoleModels::Generic
  def self.included(base) 
    base.extend RoleModels::Base       
    base.orm_name = :generic    
  end
end

require_all File.dirname(__FILE__) + '/strategies'

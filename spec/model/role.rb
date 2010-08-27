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

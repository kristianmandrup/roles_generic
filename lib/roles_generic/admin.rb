module AdminRoleCheck
  def admin?
    self.to_s.downcase.to_sym == :admin
  end
end  

class String
  include AdminRoleCheck
end

class Symbol
  include AdminRoleCheck
end

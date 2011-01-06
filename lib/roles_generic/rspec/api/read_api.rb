class Role
end

describe 'Roles Generic API : READ' do
  before :each do
    default_user_setup    
  end

  describe '#valid_role?' do
    it "should be true that the admin user has a valid role of :guest" do      
      @admin_user.valid_role?(:guest).should be_true
    end
  end
  
  describe '#valid_roles' do
    it "should be true that the admin user has a valid role of :guest" do      
      @admin_user.valid_roles.should include(:guest, :admin)
    end  
  end
  
  describe '#valid_roles?' do
    it "should be true that the admin user has a valid role of :guest" do      
      @admin_user.valid_roles?(:guest, :admin).should be_true
    end
  
    it "should be true that the User class has a valid role of :guest" do      
      User.valid_roles?(:guest, :admin).should be_true
    end
  end
  
  describe '#has_role?' do     
    it "should have admin user role to :admin and not to :user" do            
      @admin_user.has_role?(:user).should be_false
      @admin_user.has_role?(:admin).should be_true
    end
  
    it "should be true that guest user has role :user and not :admin" do      
      @guest_user.has_role?(:guest).should be_true    
      @guest_user.has_role?(:admin).should be_false
    end
  end
  
  describe '#has?' do    
    it "should be true that the admin_user has the :admin role" do      
      @admin_user.has?(:admin).should be_true      
    end
  
    it "should NOT be true that the admin_user has the :admin role" do      
      @guest_user.has?(:admin).should be_false
    end
  end
  
  describe '#has_roles?' do
    it "should be true that the normal user has the roles :guest and :user" do      
      @normal_user.has_roles?(:guest, :user).should be_true
    end

    it "should NOT be true that the normal user has the roles :guest and :admin" do      
      @normal_user.has_roles?(:guest, :admin).should be_false
    end
  
    it "should NOT be true that the user has the roles :admin" do
      @guest_user.has_roles?(:admin).should be_false
    end
  end

  describe '#has_roles?' do
    it "should be true that the normal user has the roles :guest and :user" do      
      @normal_user.has_any_role?(:guest, :user).should be_true
    end

    it "should be true that the normal user has one of the roles :guest or :admin" do      
      @normal_user.has_any_role?(:guest, :admin).should be_true
    end
  
    it "should NOT be true that the user has the roles :admin" do
      @guest_user.has_any_role?(:admin).should be_false
    end
  end
  
  describe '#roles_list' do
    it "should be true that the first role of admin_user is the :admin role" do      
      @admin_user.roles_list.should include(:admin)
    end
  
    it "should be true that the first role of admin_user is the :user role" do            
      case @normal_user.class.role_strategy.multiplicity
      when :single
        if @normal_user.class.role_strategy.name == :admin_flag
          @normal_user.roles_list.should include(:guest)
        else
          @normal_user.roles_list.should include(:user)
        end
      when :multi
        @normal_user.roles_list.should include(:user, :guest)
      end
    end
  end  
  
  describe '#roles' do
    it "should be true that the roles of admin_user is an array with the role :admin" do      
      roles = @admin_user.roles
      if roles.kind_of? Role
        roles.name.to_sym.should == :admin
      elsif roles.kind_of? Array
        if @normal_user.class.role_strategy.type == :complex
          # roles.first.name.to_sym.should == :admin
          roles.first.to_sym.should == :admin
        else
          roles.first.to_sym.should == :admin          
        end
      else       
        roles.to_sym.should == :admin
      end
    end
  end 
  
  describe '#admin?' do    
    it "should be true that admin_user is in the :admin role" do      
      @admin_user.admin?.should be_true
    end
  
    it "should NOT be true that the user is in the :admin role" do      
      @guest_user.admin?.should be_false
    end
  end
  
  describe '#is?' do          
    it "should be true that admin_user is in the :admin role" do      
      @admin_user.is?(:admin).should be_true
    end
  
    it "should NOT be true that the user is in the :admin role" do      
      @guest_user.is?(:admin).should be_false
    end
  end  
end
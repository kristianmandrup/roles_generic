class Role
end

describe 'Roles Generic API : WRITE' do
  before :each do
    default_user_setup    
  end
  
  describe '#roles=' do
    it "should set user role to :admin" do
      @guest_user.roles = :admin      
      @guest_user.has_role?(:admin).should be_true      
      @guest_user.roles = :guest            
    end    
  end
  
  describe '#exchange_roles' do
    it "should exchange user role :user with role :admin" do
      @guest_user.exchange_role :guest, :with => :admin      
      @guest_user.has?(:guest).should be_false
      @guest_user.has?(:admin).should be_true
    end    
  
    it "should exchange user role :admin with roles :user and :guest" do
      case @admin_user.class.role_strategy.multiplicity
      when :single     
        lambda { @admin_user.exchange_role :admin, :with => [:user, :guest] }.should raise_error
      when :multi
        @admin_user.has_role?(:user).should be_true
        @admin_user.has_role?(:guest).should be_true
        @admin_user.has?(:admin).should be_false        
      end
    end    
  end 
  
  describe '#remove_roles' do
    it "should remove user role :admin using #remove_roles" do
      @admin_user.remove_roles :admin
      @admin_user.has_role?(:admin).should_not be_true
    end    
  
    it "should remove user role :admin using #remove_role" do
      @guest_user.add_role :admin
      @guest_user.has_role?(:admin).should be_true
      @guest_user.remove_role :admin
      @guest_user.has_role?(:admin).should_not be_true
    end  
  end
end
class Role
end

describe 'Roles Generic API : GROUP' do
  before :each do
    default_user_setup    
  end

  describe '#add_group' do
    it "should add a group with multiple roles" do
      User.add_role_group(:guests => [:user, :guest]).should be_true
      User.role_groups[:guests].should include(:user)
    end

    it "should not add a group using hash of multiple groups" do
      lambda { User.add_role_group(:guests => [:user, :guest], :editors => :editor) }.should raise_error
    end
  end

  describe '#add_groups' do
    it "should add a group with multiple roles" do
      User.add_role_groups :guests => [:user, :guest], :editors => :editor
      User.role_groups[:guests].should include(:user)
      User.role_groups[:editors].should include(:editor)
    end
  end
  
  describe '#is_in_group' do
    it "should be true that the admin user has a valid role of :guest" do      
      User.add_role_groups :guests => [:user, :guest], :editors => :editor
      @admin_user.is_in_group?(:editors).should be_false
      @normal_user.is_in_group?(:guests).should be_true
    end
  end
  
  describe '#is_in_groups' do
    it "should be true that the admin user has a valid role of :guest" do      
      User.add_role_groups :guests => [:user, :guest], :users => :user
      @admin_user.is_in_groups?(:guests).should be_false
      @normal_user.is_in_groups?(:guests, :users).should be_true
    end
  end
  
  describe '#is_in_any_group' do
    it "should be true that the admin user has a valid role of :guest" do      
      User.add_role_groups :guests => [:user, :guest], :editors => :editor
      @admin_user.is_in_any_group?(:guests).should be_false
      @normal_user.is_in_any_group?(:guests, :editors).should be_true
    end
  end  
end
describe 'Roles Generic API : User class' do
  describe '#in_role' do
    it "should return first user matching role" do        
      if User.respond_to? :in_role
        User.in_role(:guest).first.name.should == 'Guest user'
        User.in_role(:admin).first.name.should == 'Admin user'
      end
    end
  end

  describe '#in_roles' do
    it "should return first user matching role" do        
      if User.respond_to? :in_roles
        User.in_roles(:guest, :user).first.name.should == 'Guest user'      
        User.in_roles(:admin, :guest).should be_empty
      end
    end
  end
  
  describe '#valid_role?' do
    it "should be true that the User class has a valid role of :guest" do      
      User.valid_role?(:guest).should be_true
    end
  end  
  
  describe '#valid_roles' do
    it "should be true that the User class has a valid role of :guest" do      
      User.valid_roles.should include(:guest, :admin)
    end
  end  
end
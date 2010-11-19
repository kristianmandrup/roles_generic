describe 'Roles Generic API : READ' do
  before :each do
    default_user_setup    
  end

  describe '#valid_role?' do
    it "should be true that the admin user has a valid role of :guest" do      
      @admin_user.valid_role?(:guest).should be_true
    end
  end
end
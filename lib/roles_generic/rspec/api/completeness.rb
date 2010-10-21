describe 'Roles Generic API : Completeness test' do
  before :each do
    default_user_setup    
  end

  it "should be true that a User that includes Roles::Generic has a complete Roles::Generic interface" do
    # mutation API
    [:roles=, :role=, :add_roles, :add_role, :remove_role, :remove_roles, :exchange_roles, :exchange_role].each do |api_method|
      @admin_user.respond_to?(api_method).should be_true
    end

    # inspection API
    [:valid_role?, :valid_roles?, :has_roles?, :has_role?, :has?, :is?, :roles, :roles_list, :admin?].each do |api_method|
      @admin_user.respond_to?(api_method).should be_true
    end                  

    # class method API
    [:valid_role?, :valid_roles?, :valid_roles].each do |class_api_method|
      @admin_user.class.respond_to?(class_api_method).should be_true
    end
  end
end
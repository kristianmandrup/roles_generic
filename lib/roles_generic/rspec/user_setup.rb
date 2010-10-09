def default_user_setup
  @admin_user   = User.new 'Admin user',  :admin
  @normal_user  = User.new 'Normal user', :user, :guest    
  @guest_user   = User.new 'Guest user',  :guest
end


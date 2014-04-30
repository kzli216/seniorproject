class CreateAdminService
  def call
    	kevin = User.create!({:email => "kevin.z.li@yale.edu", :password => "changemee", :password_confirmation => "changemee" })
    	kevin.confirm!
    	kevin.admin!
  end
end

class CreateAdminService
  def call
    user = User.new
        user.password = "changemee"
        user.password_confirmation = "changemee"
        user.email = "kevin.z.li@yale.edu"
        user.name = "Kevin Li"
        user.confirm!
        user.admin!
  end
end

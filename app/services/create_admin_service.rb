class CreateAdminService
  def call
    user = User.find_or_create_by!(email: => "kevin.z.li@yale.edu") do |user|
        user.password = "changeme"
        user.password_confirmation = "changeme"
        user.confirm!
        user.admin!
      end
  end
end

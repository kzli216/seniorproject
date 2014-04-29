class UsersController < ApplicationController
	before_filter :authenticate_user!
	after_action :verify_authorized, except: [:show, :following, :followers, :index, :autocomplete]

  	def index
	    if params[:query].present?
	      @users = User.search(params[:query], page: params[:page])
	    else
	      @users = User.all.paginate(page: params[:page])
	    end
  	end

  	def autocomplete
    	render json: User.search(params[:query], autocomplete: true, limit: 10).map(&:email)
	end

	def show
		@user = User.find(params[:id])
 	#	 unless current_user.admin?
	#		 unless @user == current_user
	#			 redirect_to root_path, :alert => "Access denied."
 	#		 end
 	#	 end
	end

	def update
		@user = User.find(params[:id])
		authorize @user
		if @user.update_attributes(secure_params)
			redirect_to users_path, :notice => "User updated."
		else
			redirect_to users_path, :alert => "Unable to update user."
		end
	end

	def destroy
		user = User.find(params[:id])
		authorize user
		unless user == current_user
			user.destroy
			redirect_to users_path, :notice => "User deleted."
		else
			redirect_to users_path, :notice => "Can't delete yourself."
		end
	end

	def following
		@title = "Following"
		@user = User.find(params[:id])
		@users = @user.followed_users.paginate(page: params[:page])
		render 'show_follow'
	end

	def followers
		@title = "Followers"
		@user = User.find(params[:id])
		@users = @user.followers.paginate(page: params[:page])
		render 'show_follow'
	end

	private

	def secure_params
		params.require(:user).permit(:role)
	end
end

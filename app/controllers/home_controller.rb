class HomeController < ApplicationController
	def index
		if current_user != nil
			@feed_items = current_user.feed.paginate(page: params[:page], :per_page => 15)
		end
	end
end

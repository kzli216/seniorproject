class HomeController < ApplicationController
	def index
		if current_user != nil
			@feed_items = current_user.feed.paginate(page: params[:page])
		end
	end
end

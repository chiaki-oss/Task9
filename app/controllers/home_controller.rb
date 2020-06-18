class HomeController < ApplicationController
	def index
	end
	def about
	end
	def logout
		session[:user_id] = nil
		redirect_to root_path,flash: {notice: "Signed out successfully."}
	end
end

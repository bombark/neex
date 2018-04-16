class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	layout "application"


	def index
		@current_user = current_user
	end


	#private
	@current_user = nil
	def current_user
		if @current_user.nil? && session[:user_id].present?
			@current_user = User.find(session[:user_id])
		end
		return @current_user
	end

end

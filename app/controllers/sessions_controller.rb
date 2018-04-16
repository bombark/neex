class SessionsController < ApplicationController
	def new
	end


	def create
		begin
			#user = User.find_by_email(params[:session][:email])
			session[:user_id] = "22:0"#user.id;
			redirect_to :root;
		rescue
			redirect_to "/login", alert:"Usuario ou Senha invalida"
		end
	end

	def destroy
		reset_session
		redirect_to :root
	end

end

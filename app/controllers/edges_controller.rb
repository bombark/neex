class EdgesController < ApplicationController
	before_filter :authorize

	def user_add_friend
		@cur = current_user
		@user = User.find(params[:id])
		if @cur.friends.inside?(@user.id) == false
			@cur.friends.put(@user.id)
		else
			redirect_to @user.path, notice: 'Friend aaaaaaaaaaaaa'
			return;
		end
		redirect_to @user.path, notice: 'Friend added'
	end

	def user_del_friend
		redirect_to @user.path, notice: 'Friend removed'
	end


	def user_enter_group
		group = Group.find(params[:id])
		if group.members.inside?(current_user) == false
			group.members.put(current_user)
		end
		redirect_to group.path, notice: 'Entrou'
	end

	def user_leave_group
	end


	def user_follow_node
		@cur = current_user
		@obj = Dbnode.find(params[:id])
		if not @obj.followers.inside? (@cur)
			@obj.followers.put(@cur)
		end
		redirect_to @obj.path, notice: 'Ok!'
	end

	def user_unfollow_project
	end


	def user_enter_project
		@cur = current_user
		@group = Group.find(params[:id])
		@cur.group.newEdgeTo(@group.id)
		redirect_to @group.path, notice: 'Friend removed'
	end

	def user_leave_project
	end



	def user_visits
		place = Place.find(params[:id])
		place.visitors.putOnce(current_user)
		redirect_to place.path, notice: 'Entrou'
	end

	def user_lives
		place = Place.find(params[:id])
		place.dwellers.putOnce(current_user)
		place.visitors.putOnce(current_user)
		redirect_to place.path, notice: 'Entrou'
	end


	def authorize
		#if current_user.nil?
		#	redirect_to "/login"
		#end
	end



	def update
		id     = params[:node][:id]
		upload = params[:node][:bitstream]
		node   = Dbnode.find(id)
		path = "public/imagens"
		FileUtils::mkdir_p path
		url  = File.join(path, "#{id}.jpg")
		File.open(url, "wb") do |f|
			f.write(upload.read)
		end
		redirect_to :back
		#redirect_to node.path, notice: 'Atualizado'
	end


end

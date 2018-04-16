class UsersController < ApptNodeController

	def index
		@users = User.all
		nodepkg_render("index",@users)
	end

	def index_news
		@super  = User.findCode(params[:user_id])
		#@friends = @super.friends.all
		#node_render("show", @super, "users/index", @friends)
	end

	def index_friends
		@super  = User.findCode(params[:user_id])
		@friends = @super.friends.all
		node_render("show", @super, "users/index", @friends)
	end

	def index_groups
		@super  = User.findCode(params[:user_id])
		@groups = @super.groups.all
		node_render("show", @super, "users/index", @groups)
	end

	def index_projects
		@super  = User.findCode(params[:user_id])
		@projects = @super.projects.all
		node_render("show", @super, "users/index", @projects)
	end

protected
	def node_create(args={})
		return User.new(args)
	end

	def node_find
		node = User.findCode(params[:id])
		if node.blank?
			raise "is null"
		end
		return node
	end

	def node_params
		params.require(:user).permit(:code, :name, :email, :phone)
	end

	def create_obj(args={})
		return User.new(args)
	end
end

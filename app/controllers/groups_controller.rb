class GroupsController < ApptNodeController
	def index
		@groups = Group.all
		nodepkg_render("groups/index",@groups)
	end

  # GET /units/1
  # GET /units/1.json
	#def show
		#node_render("show",@group)
		#render "show",locals:{node:@group, main: "", user: current_user}
	#end

	def index_news
		@super  = Group.find(params[:group_id])
		@articles = @super.articles.all
		node_render("show", @super, "articles/index", @articles)
	end

	def index_groups
		@super  = Group.find(params[:group_id])
		@groups = @super.groups.all
		node_render("show", @super, "groups/index", @groups)
	end


	def local_new_group
		#@group = Group.find(params[:group_id])
		@node  = Group.new
		@node._local_id = params[:group_id]
		render "new"
	end

	def index_members
		@super  = Group.find(params[:group_id])
		@members = @super.members.all
		node_render("show", @super, "users/index", @members)
	end


	def index_projects
		@super  = Group.find(params[:group_id])
		@projects = @super.projects.all
		node_render("show", @super, "projects/index", @projects)
	end

	def local_new_project
		#@group = Group.find(params[:group_id])
		@node  = Project.new
		@node._local_id = params[:group_id]
		render("projects/new")
	end

protected
	def node_create(args={})
		return Group.new(args)
	end

	def node_params
		params.require(:group).permit(:code, :name, :_local_id)
	end

end

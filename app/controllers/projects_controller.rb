class ProjectsController < ApptNodeController

	def index
		@projects = Project.all
		nodepkg_render("index",@projects)
	end


protected
	def node_create(args={})
		return Project.new(args)
	end

	def node_params
		params.require(:project).permit(:name, :brief, :description, :_local_id)
	end

	def create_obj(args={})
		return Project.new(args)
	end
end

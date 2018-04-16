class HomeController < ApptNodeController
	def show
		@cur_user = current_user
		if params[:edge].present?
			edge = params[:edge]
			#@objs = ViewCollection.new
			if edge == "friends"
				@objs = @cur_user.friends.all
				node_render("show", @super, "shared/_collection", @objs)
			elsif edge == "groups"
				@objs = @cur_user.groups.all
				node_render("show", @super, "shared/_collection", @objs)
			elsif edge == "projects"
				@objs = @cur_user.projects.all
				node_render("show", @super, "shared/_collection", @objs)
			end
		else
			node_render("show", @super)
		end

	end

	def index_groups
		@super  = current_user
		@groups = @super.groups.all
		node_render("show", @super, "groups/index", @groups)
	end

	def index_projects
		@super  = current_user
		@groups = @super.groups.all
		node_render("show", @super, "groups/index", @groups)
	end



	def filesystem
	end

	def contacts
		person = Person.new
		person.load
		render json: person
	end
end


class ViewCollection
	attr_accessor :data

	def of
		return "friend"
	end

	def name
		return "Amigos"
	end

	def data
		@data ||= []
		return @data
	end
end

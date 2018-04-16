class PeopleController < ApptNodeController
	def index
	end


protected
	def node_params
		params.require(:person).permit(:name,:birth,:work,:facebook,:email)
	end
end

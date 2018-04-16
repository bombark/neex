class TasksController < ApptNodeController

	def node_params
		params.require(:task).permit(:name, :description)
	end
end

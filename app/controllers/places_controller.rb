class PlacesController < ApptNodeController

	def index
		@places = Place.all
		nodepkg_render("index",@places)
	end

protected
	def node_params
		params.require(:place).permit(:code, :name)
	end

	def node_create(args={})
		return Place.new(args)
	end
end

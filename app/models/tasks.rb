class Task < Dbnode
	attr_accessor :name, :description

	has_many "members",   edge:"participes",   type: "in"
	has_many "followers", edge:"follows",      type: "in"

	def thumbnail
		if File.exists?("public/imagens/#{@id}.jpg")
			return "/imagens/#{@id}.jpg"
		else
			return "/defaults/project.png"
		end
	end
end

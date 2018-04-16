class Project < Dbnode
	attr_accessor :name, :brief, :description, :is_public

	has_many "authors",   edge:"has_projects", type: "in"
	has_many "members",   edge:"participes",   type: "in"
	has_many "followers", edge:"follows",      type: "in"

	def create(author)
		save
		self.authors.put(author)
		if ( _local_id.present? )
			self.authors.put(_local_id)
		end
	end


	def thumbnail
		if File.exists?("public/imagens/#{@id}.jpg")
			return "/imagens/#{@id}.jpg"
		else
			return "/defaults/project.png"
		end
	end
end

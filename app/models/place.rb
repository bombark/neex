class Place < Dbnode
	attr_accessor :code, :name, :description

	has_many "visitors", edge:"visits",  type: "in"
	has_many "dwellers", edge:"lives",   type: "in"

	def create(author)
		self.save
	end

	def thumbnail
		if File.exists?("public/imagens/#{@id}.jpg")
			return "/imagens/#{@id}.jpg"
		else
			return "/defaults/group.png"
		end
	end
end

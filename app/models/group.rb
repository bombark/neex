class Group < Unit
	attr_accessor :email, :phone, :facebook, :is_public
	attr_accessor :_local_id

	has_many "super",     edge:"has_sons",     type: "out"
	has_many "groups",    edge:"has_sons",     type: "in"
	has_many "projects",  edge:"has_projects", type: "out"
	has_many "members",   edge:"has_members",  type: "out"
	has_many "followers", edge:"follows",      type: "in"

	has_many "articles",  edge:"has_articles", type: "out"

	def create(author)
		self.save
		self.members.put author
		if _local_id.present?
			self.super.put(_local_id)
		end
	end


	def thumbnail
		if File.exists?("public/imagens/#{@id}.jpg")
			return "/imagens/#{@id}.jpg"
		else
			return "/defaults/group.png"
		end
	end
end

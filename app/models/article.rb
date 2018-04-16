class Article < Dbnode
	attr_accessor :name, :brief, :description, :date

	has_many "owner",      edge:"has_articles",      type: "in"
	has_many "references", edge:"has_articles",      type: "out"


	def create(owner)
		@date = Date.today
		save()
		self.owner.put(owner)
	end
end

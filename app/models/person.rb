class Person < Dbnode
	attr_accessor :name, :birth, :email, :phone, :facebook, :work, :description

	has_many "owner", edge:"has_contacts",      type: "in"

	def create(owner)
		super()
		self.owner.put(owner)
	end
end

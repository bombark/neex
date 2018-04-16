class Unit < Dbnode
	attr_accessor :code, :name

	def save
		super
		FileUtils.mkdir_p "db/filesystem/#{@id}"
	end
end

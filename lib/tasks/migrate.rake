namespace :orientdb do
	desc "Create database"
	task :migrate do
		conn  = Bootstrap::Application.database

		#if !conn.database_exists? "Neex"
		#	conn.create_database("Neex")
		#end

		create_class conn,"Article","V"
		create_class conn,"Place","V"
		create_class conn,"Project","V"
		create_class conn,"Person","V"

		create_class conn,"Unit","V"
		create_class conn,"User","Unit"
		create_class conn,"Group","Unit"

		create_class conn,"has_sons","E"

		create_class conn,"has_articles","E"
		create_class conn,"has_friends","E"
		create_class conn,"has_members","E"
		create_class conn,"has_contacts","E"

		create_class conn,"follows","E"
		create_class conn,"participates","E"

		create_class conn,"likes","E"
		create_class conn,"visits","E"
		create_class conn,"lives","E"

		#FileUtils.mkdir_p "files/thumbnails"
		#FileUtils.mkdir_p "files/users"
	end
end





def create_class(conn, name,extends)
	if !conn.class_exists?(name)
		puts "Creating class #{name}"
		conn.create_class name,{:extends=>extends}
	end
end

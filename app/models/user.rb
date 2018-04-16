class User < Unit
	attr_accessor :email, :phone, :facebook, :lk_github, :lk_twitter, :lk_linkedin

	has_many "friends",   edge:"has_friends"
	has_many "followers", edge:"follows", type: "in"
	has_many "follows",   edge:"follows", type: "out"

	has_many "groups",    edge:"has_members", type: "in"

	has_many "projects",  edge:"has_projects", type: "out"

	has_many "places",    edge:"lives",      type: "out"

	has_many "people",    edge: "has_contacts", type: "out"

	#has_edge "execute"
	#has_one  "fs",        type: "filesystem", params: {url:}


	def path
		"/#{@classe.downcase.pluralize}/#{@code}"
	end

	def thumbnail
		if File.exists?("public/imagens/#{@id}.jpg")
			return "/imagens/#{@id}.jpg"
		else
			return "/defaults/user.png"
		end
	end
end

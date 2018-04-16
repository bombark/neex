class PublicController < ApplicationController


	def show
		@node = Dbnode.find(params[:id])
		if @node == nil
			return
		elsif @node.classe == "Group"
			render "groups/show",locals:{node:@node, user: current_user}
		elsif @node.classe == "User"
			render "users/show",locals:{node:@node, user: current_user}
		elsif @node.classe == "Project"
			render "projects/show",locals:{node:@node, user: current_user}
		end
	end


	def show_edge
		@node = Dbnode.find(params[:id])
		if @node.classe == "Group"
			render "groups/show",locals:{node:@node, user: current_user}
		elsif @node.classe == "User"
			render "users/show",locals:{node:@node, user: current_user}
		elsif @node.classe == "Project"
			template = %q{
				opa <%=node.name%> dddd
			}
			rhtml = ERB.new(template)
			rhtml.run(@node)
			#render text: message.result
			#render partial: "projects/show", locals:{node:@node, user: current_user}
		end
	end

end

class ApptNodeController < ApplicationController
	def index
		raise "not defined"
	end

	def show
		@node = node_find
		node_render("show",@node)
	end

	def new
		@node = self.node_create
	end

	def edit
		@node = node_find
	end

	def create
		@node = self.node_create(node_params)
		respond_to do |format|
			if @node.create(current_user)
				format.html { redirect_to @node, notice: 'User was successfully created.' }
				format.json { render :show, status: :created, location: @node }
			else
				format.html { render :new }
				format.json { render json: @node.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /units/1
	# PATCH/PUT /units/1.json
	def update
		@node = node_find
		respond_to do |format|
			if @node.update(node_params)
				format.html { redirect_to @node, notice: 'Unit was successfully updated.' }
				format.json { render :show, status: :ok, location: @node }
				else
				format.html { render :edit }
				format.json { render json: @node.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /units/1
	# DELETE /units/1.json
	def destroy
		@node = node_find
		@node.destroy
		respond_to do |format|
			format.html { redirect_to units_url, notice: 'Unit was successfully destroyed.' }
			format.json { head :no_content }
		end
	end


protected
	def node_find
		return Dbnode.find(params[:id])
	end

	def node_params
		raise "not defined"
	end

	def node_create
		raise "not defined"
	end



	def node_render(node_tmpl, node, nodepkg_tmpl=nil, nodepkg=nil)
		main = ""
		if nodepkg_tmpl.present?
			main = render_to_string nodepkg_tmpl,
				locals:{node:node, nodepkg:nodepkg, user: current_user},
				:layout => false
		end
		page = render_to_string node_tmpl,
			locals:{node:node, main: main, user: current_user},
			:layout => "application"
		render text: page
	end

	def nodepkg_render(tmpl,nodepkg)
		render tmpl, locals:{node: nil, nodepkg:nodepkg, user: current_user}
	end
end

class ArticlesController < ApptNodeController

	def index
		articles = Article.all
		nodepkg_render("index",articles)
	end

protected
	def node_params
		params.require(:article).permit(:name,:brief,:description)
	end

	def node_create(args={})
		return Article.new(args)
	end
end

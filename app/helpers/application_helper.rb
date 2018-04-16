module ApplicationHelper
	def image_sm(unit)
		return "<img src=\"#{unit.thumbnail}\" width=64>".html_safe
	end

	def image_md(unit)
		return "<img src=\"#{unit.thumbnail}\" width=128>".html_safe
	end

	def title(title,args={})
		res = "<h2>#{title}";
		if args[:count].present?
			res += "<span class=\"badge badge-info\">#{args[:count]}</span>"
		end
		if args[:add].present?
			res += "<div class='pull-right'><a href=\"#{args[:add]}\" class=\"btn btn-primary\"> Add </a></div>"
		end
		res += "</h2>"
		return res.html_safe
	end






	def card(unit)
		res = "<div class=\"card flex-md-row mb-4 box-shadow h-md-250\">"
		res += "<a href='#{unit.path}'>"
		res += "<img class=\"card-img-right d-md-block\" src=\"#{unit.thumbnail}\" alt=\"Card image cap\" width=128px>"
		res += "</a>"
		res += "<div class=\"card-body d-flex flex-column align-items-start\">"
		res += "<h3 class=\"mb-0\">"
		res += link_to unit.name, unit.path, class: "text-dark"
		res += "</h3>"
		res += "<div class=\"mb-1 text-muted\">Nov 12</div>"
		res += "<p class=\"card-text mb-auto\"></p>"
		res += "</div></div>"
		return res.html_safe
	end


	def teste(unit)
		res = "<div class=\"card flex-md-row mb-4 box-shadow h-md-250\">"
		res += "<div class=\"card-body d-flex flex-column align-items-start\">"
		res += "<strong class=\"d-inline-block mb-2 text-success\">Design</strong>"
		res += "<h3 class=\"mb-0\">"
		res += "<a class=\"text-dark\" href=\"#\">#{unit.name}</a>"
		res += "</h3>"
		res += "<div class=\"mb-1 text-muted\">Nov 11</div>"
		res += "<p class=\"card-text mb-auto\">This is a wider card with supporting text below as a natural lead-in to additional content.</p>"
		res += "<a href=\"#\">Continue reading</a>"
		res += "</div>"
		res += "<img class=\"card-img-right flex-auto d-none d-md-block\" data-src=\"holder.js/200x250?theme=thumb\" alt=\"Thumbnail [200x250]\" style=\"width: 200px; height: 250px;\" src=\"data:image/svg+xml;charset=UTF-8,%3Csvg%20width%3D%22200%22%20height%3D%22250%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%20200%20250%22%20preserveAspectRatio%3D%22none%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%23holder_162837d68b1%20text%20%7B%20fill%3A%23eceeef%3Bfont-weight%3Abold%3Bfont-family%3AArial%2C%20Helvetica%2C%20Open%20Sans%2C%20sans-serif%2C%20monospace%3Bfont-size%3A13pt%20%7D%20%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cg%20id%3D%22holder_162837d68b1%22%3E%3Crect%20width%3D%22200%22%20height%3D%22250%22%20fill%3D%22%2355595c%22%3E%3C%2Frect%3E%3Cg%3E%3Ctext%20x%3D%2258%22%20y%3D%22130.7%22%3EThumbnail%3C%2Ftext%3E%3C%2Fg%3E%3C%2Fg%3E%3C%2Fsvg%3E\" data-holder-rendered=\"true\">"
		res += "</div>"
		res += "</div>"
		return res.html_safe
	end


	def jumbotron(unit)
		res  = "<div class=\"jumbotron p-3 p-md-5 text-white rounded bg-dark\" style=\"background-image: url(https://fedoramagazine.org/wp-content/uploads/2016/10/f25-supplemental-wp-chosen-945x400.png); background-size: 100%;\"><div class=\"col-md-6 px-0\">"
		res += "<h1 class=\"display-4 font-italic\">#{unit.name}</h1>"
		res += "<p class=\"lead my-3\">descricao</p>"
		res += "</div></div>"
		return res.html_safe
	end

	def followed_button(obj,current_user)
		if obj.followers.inside?(current_user)
			return link_to "deseguir","/edges/unfollow?id=#{obj.id}"
		else
			return link_to "seguir","/edges/follow?id=#{obj.id}"
		end
	end

	def button_enter(obj,current_user)
		if obj.members.inside?(current_user)
			return link_to "sair","/edges/leave?id=#{obj.id}"
		else
			return link_to "entrar","/edges/enter?id=#{obj.id}"
		end
	end
end

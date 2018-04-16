class Chat

	def initialize(to)
		@url = "db/chat/#{from}/#{to}.csv"
	end

	def send(msg)
		line = "111;felipe;#{msg}\n";
		File.open(@url, "a") do |f|
			f.write(line)
		end
	end

	def list
	end
end

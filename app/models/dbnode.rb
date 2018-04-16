class Dbnode
	include ActiveModel::Model
	include ActiveModel::Naming

	attr_accessor  :id
	attr_accessor  :_local_id
	@@db = Bootstrap::Application.database



	def initialize(raw={})
		if raw["rid"].present?
			@id = raw["rid"].tr("#","")
		elsif raw["@rid"].present?
			@id = raw["@rid"].tr("#","")
		end
		@classe = @classe || self.class.to_s

		@_altered = []
		raw.each do |key, val|
			if key[0] == '@'
				next
			end
			if val.is_a?(Array)
				#if (key[0..3] == "out_")
				#	key = key[4..key.size]
				#	edge = Edge.new(@id,key);
				#	key = key.downcase
				#	self.instance_variable_set("@#{key}", edge)
				#	self.class_eval("def #{key};@#{key};end")
				#elsif (key[0..2] == "in_")
				#	key = key[3..key.size]
				#	edge = Edge.new(@id,key);
				#	key = key.downcase
				#	self.instance_variable_set("@#{key}", edge)
				#	self.class_eval("def #{key};@#{key};end")
				#else
				#	list = EmbeddedList.new(@id,key)
				#	self.instance_variable_set("@#{key}", list)
				#	self.class_eval("def #{key};@#{key};end")
				#	#self.class_eval("def #{key}=(val);@#{key}=val;end")
				#end
			else
				#self.public_send("#{attr}=", value)
				self.instance_variable_set("@#{key}", val)
				self.class_eval("def #{key};@#{key};end")
				self.class_eval("def #{key}=(val);@#{key}=val; @_altered.push(#{key}); end")

				if @id.blank? and key[0] != '_'
					@_altered.push(key)
				end
			end
		end
		return self
	end

	def classe
		return model_name
	end


	# METAPROGRAMING

	def self.odbvertex(name)
		@classe = name
		#self.class_eval("def #{classe};@#{arg};end")
	end


	def self.has_many(name, args={})
		edge_name = args[:edge] || name;
		type="EdgeAll"
		if args[:type].present?
			if args[:type] == "in"
				type = "EdgeIn"
			elsif args[:type] == "out"
				type = "EdgeOut"
			elsif args[:type] != "all"
				raise "error type=[in,out,all]"
			end
		end
		self.class_eval("def #{name};@#{name}||=#{type}.new(@id,'#{edge_name}'); @#{name}; end")

		@@meta ||= {}
		if @@meta[self.model_name].present?
			@@meta[self.model_name].push( name )
		else
			@@meta[self.model_name] = [name]
		end
	end





	# ACTIVE RECORD API

	def self.all()
		return select_from( self.model_name )
	end

	def all(path)
		if path.size == 0
			return Dbnode.select_from( self.model_name )
		else
			node = path.read
			cur  = Dbnode.find(node)
			if path.size == 0
				return Dbnode.find(node)
			else
				node = path.read
				cur = cur.send("#{node}").all
				#return []
			end
		end
	end

	def self.find(id)
		if id.nil?
			raise "Id is nill"
		end
		raw = @@db.get_document "##{safe_sql(id)}"
		cls = Object.const_get( raw["@class"] )
		obj = cls.new(raw)
		return obj
	end

	def self.findCode(code)
		if code.nil?
			raise "Id is nil"
		end
		raw = @@db.query "select * from #{self.model_name} where code='#{safe_sql(code)}'"
		cls = Object.const_get( raw[0]["@class"] )
		obj = cls.new(raw[0])
		return obj
	end

	def self.count
		raw = @@db.query "SELECT count(@rid) FROM #{self.model_name}"
		return raw[0]["count"]
	end


	def to_insert_sql
		sql = "";
		@_altered.each do |key|
			if key==:id || key==:classe; next; end;
			val = self.instance_variable_get("@#{key}")
			if val.is_a? String
				sql += "#{key}='#{safe_sql(val)}',"
			elsif
				sql += "#{key}=#{val},"
			end
		end
		return sql[0..sql.size-2]
	end

	def save
		if @rid.present?
			sql = self.to_insert_sql
			raise sql
		else
			sql = self.to_insert_sql
			@id = Dbnode.insert_into(@classe, sql)
		end
	end


	def destroy
		if @id.nil?
			raise "Id is nil"
		end
		return @@db.command "DELETE VERTEX #{@id}"
	end



	# SQL API
	def self.select_from(classe)
		if classe == ""
			raise "Class is Nil"
		end
		#app = Object.const_get('Vertice')
		res = Array.new
		raw = @@db.query "SELECT FROM #{classe}"
		for node in raw
			cls = Object.const_get( node["@class"] )
			obj = cls.new(node)
			res.push( obj )
		end
		return res
	end


	def self.insert_into(classe, sql)
		begin
			res = @@db.command "INSERT INTO #{classe} SET #{sql}"
			return res["result"][0]["@rid"].tr("#","")
			#return self.find(@id)
		rescue
			raise "INSERT INTO #{classe} SET #{sql}"
		end
	end


	def update (sql)
		sql.each do |key,val|
			if key[0] == '_'; next; end;
			self.instance_variable_set("@#{key}",val);
			@_altered.push(key)
		end
		if @id.nil?
			raise "Id is nil"
		end
		sql_str = self.to_insert_sql
		@@db.command "UPDATE ##{@id} SET #{sql_str}"
	end

	## Necessario para model e naming
	def persisted?
		!(self.id.nil?)
	end

	## active model Api
	def path
		"/#{@classe.downcase.pluralize}/#{@id}"
	end

	def meta
		return @@meta[self.model_name]
	end
end




def safe_sql(text)
	return text.gsub("\"","").gsub("\'","").gsub("\r\n","\\n")
end







class EmbeddedList
	@@db = Bootstrap::Application.database

	def initialize(root_id, field)
		@root_id = root_id
		@field = field
		@data = NIL
	end

	def all
		return (@data.present?) ? @data : self.load
	end

	def put(id)
		#raise "UPDATE #{@root_id} ADD #{@field}=#{id}"
		@@db.command "UPDATE #{@root_id} ADD #{@field}=#{id}"
	end

	def load
		@data = []
		raw = @@db.query "SELECT expand(#{@field}) FROM #{@root_id}"
		for node in raw
			cls = Object.const_get( node["@class"] )
			obj = cls.new(node)
			@data.push( obj )
		end
		@data
	end
end




class Edge
	@@db = Bootstrap::Application.database

	def initialize(root_id, edge_name)
		@root_id   = root_id
		@edge_name = edge_name
		@data      = NIL
	end

	def all
		return (@data.present?) ? @data : self.load
	end

	def load
		return []
	end

	def toId(obj)
		if obj.is_a? String
			return obj
		elsif obj.is_a? Object
 			return obj.id
		end
	end

	def putOnce(obj)
		if self.inside?(obj) == false
			self.put(obj)
		end
	end

	def put(obj)
		raise "Not implemented"
	end

	def inside?(obj)
		raise "Not implemented"
	end
end


class EdgeAll < Edge
	def put(id)
		@@db.command "CREATE EDGE #{@edge_name} FROM #{@root_id} TO #{id}"
	end

	def remove(id)
	end

	def inside?(id)
		raw = @@db.query "SELECT FROM (SELECT expand(out_#{@edge_name}) FROM ##{@root_id}) WHERE in=##{id}"
		return raw[0].present?
	end

	def load
		@data = []
		raw = @@db.query "SELECT expand(in) FROM (SELECT expand(out_#{@edge_name}) FROM #{@root_id})"
		for node in raw
			cls = Object.const_get( node["@class"] )
			obj = cls.new(node)
			@data.push( obj )
		end
		raw = @@db.query "SELECT expand(out) FROM (SELECT expand(in_#{@edge_name}) FROM #{@root_id})"
		for node in raw
			cls = Object.const_get( node["@class"] )
			obj = cls.new(node)
			@data.push( obj )
		end
		@data
	end

end


class EdgeIn < Edge
	def put(obj)
		id = self.toId(obj)
		@@db.command "CREATE EDGE #{@edge_name} FROM #{id} TO #{@root_id}"
	end

	def inside?(obj)
		id = self.toId(obj)
		raw = @@db.query "SELECT FROM (SELECT expand(in_#{@edge_name}) FROM ##{@root_id}) WHERE out=##{id}"
		return raw[0].present?
	end

	def load
		@data = []
		raw = @@db.query "SELECT expand(out) FROM (SELECT expand(in_#{@edge_name}) FROM #{@root_id})"

		for node in raw
			cls = Object.const_get( node["@class"] )
			obj = cls.new(node)
			@data.push( obj )
		end
		@data
	end

	def count
		raw = @@db.query "SELECT in_#{@edge_name}.size() AS size FROM #{@root_id}"
		if raw[0]["size"].present?
			return raw[0]["size"]
		else
			return 0
		end
	end
end



class EdgeOut < Edge

	def put(obj)
		id = self.toId(obj)
		@@db.command "CREATE EDGE #{@edge_name} FROM #{@root_id} TO #{id}"
	end

	def inside?(obj)
		id = self.toId(obj)
		raw = @@db.query "SELECT FROM (SELECT expand(out_#{@edge_name}) FROM ##{@root_id}) WHERE in=##{id}"
		return raw[0].present?
	end

	def load
		@data = []
		raw = @@db.query "SELECT expand(in) FROM (SELECT expand(out_#{@edge_name}) FROM #{@root_id})"
		for node in raw
			cls = Object.const_get( node["@class"] )
			obj = cls.new(node)
			@data.push( obj )
		end
		@data
	end

	def count
		raw = @@db.query "SELECT out_#{@edge_name}.size() AS size FROM #{@root_id}"
		if raw[0]["size"].present?
			return raw[0]["size"]
		else
			return 0
		end
	end
end

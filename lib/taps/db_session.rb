Sequel::Model.db = Sequel.connect(Taps::Config.taps_database_url)

class DbSession < Sequel::Model
	plugin :schema
	set_schema do
		primary_key :id
		text :key
		text :database_url
		text :schema
		timestamp :started_at
		timestamp :last_access
	end

	def conn
		Sequel.connect(database_url) do |db|
			db.run("ALTER SESSION SET current_schema=#{schema}") if schema
			yield db if block_given?
		end
	end
end

DbSession.create_table! unless DbSession.table_exists?

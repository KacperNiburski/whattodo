
db = URI.parse('mongodb://10.8.0.1:27017/map')
db_name = db.path.gsub(/^\//, '')
@db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
@db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.password.nil?)
@db_connection

MongoMapper.connection = Mongo::Connection.new('10.8.0.1', 27017).db(db_name)
MongoMapper.database = "map"

if defined?(PhusionPassenger)
   PhusionPassenger.on_event(:starting_worker_process) do |forked|
     MongoMapper.connection.connect if forked
  end
end
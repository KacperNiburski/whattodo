MongoMapper.connection = Mongo::Connection.new('10.8.0.1', 27017)
MongoMapper.database = "map"

if defined?(PhusionPassenger)
   PhusionPassenger.on_event(:starting_worker_process) do |forked|
     MongoMapper.connection.connect if forked
  end
end
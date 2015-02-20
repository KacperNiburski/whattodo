- want to map to collection
- get all haps(or events?) by title, 

-> connect, but don't want to connect each time on startup, want to map all events to be haps for that day right?
- get events for that day
- JSON.parse(MongoMapper.connection.collection("eventsTable").find().limit(1).to_json) -> currently graps all events
coll = JSON.parse(MongoMapper.connection.collection("eventsTable").find({$and: [{"last_update_date:  {"$gte": Date.today.to_s}} , {last_update_date: {"$lt": (Date.today+1).to_s}}]})

- want to map to collection
- get all haps(or events?) by title, 

-> connect, but don't want to connect each time on startup, want to map all events to be haps for that day right?
- get events for that day
- JSON.parse(MongoMapper.connection.collection("eventsTable").find().limit(1).to_json) -> currently graps all events
coll = JSON.parse(MongoMapper.connection.collection("eventsTable").find({$and: [{"last_update_date:  {"$gte": Date.today.to_s}} , {last_update_date: {"$lt": (Date.today+1).to_s}}]})


- sudo -u postgress -i
- pg_dump whattodo_production backup.sql
- mv the_backup.sql ../../../home/rails
- rake db:drop
- rake db:create
- sudo -u postgres psql whattodo_development < the_backup.sql

  - capybara-webkit cannot be installed on heroku. This is api for wheretoobee.
  ->RAILS_ENV=production rake get_events:get_events
  -> might need to reset config file of server

  -> current routes: today or party

  -> needs wrapper

-> parsing event time in desc.
-> look for other events and how to make them look good for party people.
-> fix api geocoding all same place.
-> restaurants 12am open yelp api

sudo -u postgress -i
pg_dump whattodo_production backup.sql
mv the_backup.sql ../../../home/rails
rake db:drop
rake db:create
sudo -u postgres psql whattodo_development < the_backup.sql

NowMagazine scrapper broken, elmcity no longer around


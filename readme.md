## whattodo 

Grabs all Event Data in Toronto. Fork it to add sources or build on top of API layer.

<<<<<<< HEAD
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

tinder for events - learn how to build
web platform
scrape two more things
optomize thing
table of all lat longs for event locations
why aren't events orders by date.

NowMagazine scrapper broken, elmcity no longer around


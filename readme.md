whattodo 
  - whenever update schedule.rb -> whenever --update-cron-tab
  - run rake assets:precombile and then service unicorn restart when running on api
  -> install xfvib on ubuntu
  - ubuntu has big no read file end error, so to cirvument catch it

  -> categoryList: music seasonal cultured learn investing sport geek outdoor good party watch laugh religion food
  -> /api/v1/today?access_token=XXXX&cat=Sport&limit=10

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
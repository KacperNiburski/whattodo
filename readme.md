## whattodo 

Grabs all Event Data in Toronto. Fork it to add sources or build on top of API layer.

- sudo -u postgress -i
- pg_dump whattodo_production backup.sql
- mv the_backup.sql ../../../home/rails
- rake db:drop
- rake db:create
- sudo -u postgres psql whattodo_development < the_backup.sql

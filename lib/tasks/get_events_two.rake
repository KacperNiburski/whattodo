namespace :get_events_two do
  desc 'Grabs event part two weekly'
  task :get_events_two => :environment do 
    puts 'Does not destroy all events because comes second'

    puts 'Creating Events'
    Event.createEventsTwo

    puts "Created #{Event.all.count} Events"
  end
end

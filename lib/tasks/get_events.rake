namespace :get_events do
  desc 'Grabs event weekly'
  task :get_events => :environment do 
    puts 'Destroying all Events'
    Event.destroy_all

    puts 'Creating Events'
    Event.createEvents

    puts "Created #{Event.all.count} Events"
  end

  desc 'Fix current meetups'
  task :fix_meetup => :environment do 
    puts 'Fixing meetup'

    meetups = Event.where(source: 'Meetup')

    meetups.each do |event|
      event.dayOn = DateTime.parse(event.dayOn) + 10.hours
      event.dayEnd = DateTime.parse(event.dayEnd) + 10.hours
      event.save!
    end

    puts "Fixed #{meetups.count} meetups"
  end


  desc 'Fix current nowmagazines'
  task :fix_now => :environment do 
    puts 'Fixing meetup'

    nowmagazines = Event.where(source: 'Nowmagazine')

    nowmagazines.each do |event|
      event.dayOn = DateTime.parse(event.dayOn) + 10.hours
      event.dayEnd = DateTime.parse(event.dayEnd) + 10.hours
      event.save!
    end

    puts "Fixed #{nowmagazines.count} nowmagazines"
  end
end

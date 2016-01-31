include Capybara::DSL

require 'headless'
require 'os'

Capybara::Webkit.configure do |config|
  config.debug = false
  config.block_unknown_urls
  config.skip_image_loading
end


Capybara.configure do |config|
  config.run_server = true
  config.default_driver = :webkit
  config.app_host = 'https://nowtoronto.com/search/event/all/'
end

Capybara.javascript_driver = :webkit

module Scraper
  class NowMagazine

    def self.club_events
      # http://www.clubcrawlers.com/toronto/events/tonightsevents
      string = "http://www.clubcrawlers.com/toronto/events/tonightsevents"
      data = Nokogiri::HTML(open(string)).css('.event-block')
      eventsAll = []

      data.each do |event|

        name = event.css('.event-info h2').text()
        name = ActionView::Base.full_sanitizer.sanitize(name)
        image = "http://www.clubcrawlers.com" + event.css('.hov img').attribute('src').value
        locationAndDate = event.css('.event-info h3').text()
        #  checks if Dec. or something like that, so then know if Saturday or actual date for event
        if locationAndDate[/\./]
          location = (locationAndDate.split(/\d+\s/)[1] + ", Toronto, Canada").lstrip
          date = locationAndDate.scan(/.+\d+/)[0]
        else 
          locationAndDate = locationAndDate.split(/\s/)
          date = locationAndDate[0][0...-1]
          location = (locationAndDate[1..-1].join(" ")[1..-1] + ", Toronto, Canada").lstrip
          locationAndDate = locationAndDate.join(' ')
        end

        url = "http://www.clubcrawlers.com" + event.css('.hov').attribute('href').value

        eventsAll.push({
          name: name,
          image: image,
          url: url,
          location: location,
          price: 'Price not listed',
          dayOn: Date.today.to_s + ' 9:00 pm',
          dayEnd: (Date.today + 1).to_s + ' 2:00 am',
          desc: locationAndDate,
          categoryList: ["Party"],
          source: "Club Crawlers"
        })
      end

      @headless.destroy if !OS.mac? && !@headless.nil?
      return eventsAll
      
    end

    def self.get_events
      puts "Starting nowmagazine"
   
      if Capybara.current_driver == :webkit
        puts 'Starting headless'
        @headless = Headless.new
        @headless.start         
      end
      
      puts "Working over here yo!"
      
      eventAll = []
      page = visit('/')
      count = 0
      puts "Vist page yo!"
      while count <= 100
        puts "Starting entering stuff"        
        page.all(:css, '.event_result').each do |element|          
          name = element.find('.event_title').text()
          splitedDate = element.find('.event_date').text().split('-')
          dayOn = splitedDate[0]
          dayEnd = splitedDate[1] || DateTime.parse(splitedDate[0]) + 3.hours
          url = element.find('h4.event_title a')[:href]
          location = element.all(:css, '.event_info a')[1].text() + ', Toronto, Canada'
          desc = element.find('.description').text()[0..-8]
          price = desc[/\$\d+/] || "Free"
          categories = element.find('.cats span').text().split(/[\/\s,]/).reject!(&:empty?)
          categories = ["Misc"] if categories == nil || categories == ""
          puts "Starting one result named #{name}"
          eventAll.push({
              name: name,
              url: url,
              location: location,
              price: price,
              dayOn: dayOn,
              dayEnd: dayEnd,
              desc: desc,
              categoryList: categories,
              source: "Nowmagazine",
              image: "http://imgur.com/KfucOsR.png"
            })
        end        
        page = page.find('.next').click() rescue ""
        count += 1
      end
      return eventAll
    end
  end
end

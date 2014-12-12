include Capybara::DSL

require 'headless'
require 'os'

module Scraper
  class NowMagazine

    def self.club_events
      # this breaks on ubuntu
      begin
        string = "http://www.clubcrawlers.com/toronto/events/all-events"
        Capybara.app_host = string
        eventsAll = []
        count = 0
        page = visit('/')
       # while count < 2
        while page.has_css?('.load-more')
          page.all(:css, '.event-block').each do |event|
            name = event.find('.event-info h2').text()
            image = "http://www.clubcrawlers.com" + event.find('.hov img')[:src]
            locationAndDate = event.find('.event-info h3').text()
            #  checks if Dec. or something like that, so then know if Saturday or actual date for event
            if locationAndDate[/\./]
              location = locationAndDate.split(/\d+\s/)[1] + ", Toronto, Canada"
              date = locationAndDate.scan(/.+\d+/)[0]
            else 
              locationAndDate = locationAndDate.split(/\s/)
              date = locationAndDate[0][0...-1]
              location = locationAndDate[1..-1].join(" ") + ", Toronto, Canada"
            end

            url = "http://www.clubcrawlers.com" + event.find('.hov')[:href]

            eventsAll.push({
                name: name,
                image: image,
                url: url,
                location: location,
                price: 'Price not listed',
                dayOn: date,
                dayEnd: date,
                desc: 'A night to be remembered',
                categoryList: ["Party"],
                source: "Club Crawlers"
              })
          end

          page = page.find('.load-more').click() if page.has_css?('.load-more')
          count += 1
        end
      rescue
        # http://www.clubcrawlers.com/toronto/events/tonightsevents
        string = "http://www.clubcrawlers.com/toronto/events/tonightsevents"
        data = Nokogiri::HTML(open(string)).css('.event-block')

        data.each do |event|

          name = event.css('.event-info h2').text()
          image = "http://www.clubcrawlers.com" + event.css('.hov img').attribute('src').value
          locationAndDate = event.css('.event-info h3').text()
          #  checks if Dec. or something like that, so then know if Saturday or actual date for event
          if locationAndDate[/\./]
            location = locationAndDate.split(/\d+\s/)[1] + ", Toronto, Canada"
            date = locationAndDate.scan(/.+\d+/)[0]
          else 
            locationAndDate = locationAndDate.split(/\s/)
            date = locationAndDate[0][0...-1]
            location = locationAndDate[1..-1].join(" ") + ", Toronto, Canada"
          end

          url = "http://www.clubcrawlers.com" + event.css('.hov').attribute('href').value

          eventsAll.push({
            name: name,
            image: image,
            url: url,
            location: location,
            price: 'Price not listed',
            dayOn: date,
            dayEnd: date,
            desc: 'A night to be remembered',
            categoryList: ["Party"],
            source: "Club Crawlers"
          })
        end

      end

      @headless.destroy if !OS.mac? && !@headless.nil?
      return eventsAll
      
    end

    def self.get_events
      if !OS.mac?
        if Capybara.current_driver == :webkit
          puts 'Starting headless'
          @headless = Headless.new
          @headless.start
        end
      end
      @headless.start if !OS.mac? 
      eventAll = []
      page = visit('/')
      count = 0
      while count <= 100
        page.all(:css, '.event_result').each do |element|
          name = element.find('.event_title').text()
          splitedDate = element.find('.event_date').text().split('-')
          dayOn = splitedDate[0]
          dayEnd = splitedDate[1] || splitedDate[0]
          url = element.find('h4.event_title a')[:href]
          location = element.all(:css, '.event_info a')[1].text() + ', Toronto, Canada'
          desc = element.find('.description').text()[0..-8]
          price = desc[/\$\d+/] || "Free"
          categories = element.find('.cats span').text().split(/[\/\s,]/).reject!(&:empty?)
          categories = ["Misc"] if categories == nil || categories == ""

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
              image: "http://i.imgur.com/ixz8pZT.png?1"
            })
        end
        page = page.find('.next').click()
        count += 1
      end
      return eventAll
    end
  end
end

require 'open-uri'
require 'time'
require 'html/sanitizer'
require 'geokit'
require 'uri'
require_dependency 'scraper.rb'

class Event < ActiveRecord::Base
  include Scraper

	geocoded_by :location

  def self.writeToFile(events)
    puts 'Writing to File'
    File.open('eventsseedfile.txt', 'w') { |file| file.write(events) }
  end

  def self.callCreation(arrEvents)
    arrEvents.each do |event|
      puts event
      e = Event.new(event)
      unless e.location == "No address listed"
        if e.latitude == nil || e.longitude == nil 
          begin
            coords = Geokit::Geocoders::GoogleGeocoder.geocode e.location
            e.latitude, e.longitude = coords[0], coords[1]
            puts 'enter google'
          rescue
            fragment = e.location.gsub(',','').gsub('/','')
            if fragment.scan(/Toronto/).length >= 2
              fragment = fragment.split('Toronto',-1)[0]
            else
              fragment = fragment
            end
            url = URI.encode("http://nominatim.openstreetmap.org/search/" + fragment +"?format=json&addressdetails=1&limit=1")            

            unless url == nil || url == " " || url == ''
              puts 'enter nomaintim'
              url = JSON.parse((open(url)).read)
              coords = url[0]
              e.latitude, e.longitude = coords["lat"].to_f, coords["lon"].to_f if coords != nil
            end
          end
        end

        #http://www.mapquestapi.com/geocoding/v1/address?key=Fmjtd|luurn1u8l9%2Cbw%3Do5-9wyx0a&callback=renderOptions&inFormat=json&outFormat=json&location=20,Duncan,Street,Toronto,Canada
        if Event.last == nil || !( e.latitude.to_i - 43 >= 0 && e.latitude.to_i - 43 <= 3 ) || Event.last.latitude == e.latitude || Event.last.latitude == e.latitude || e.latitude == nil
          # http://dev.virtualearth.net/REST/v1/Locations?CountryRegion=CA&adminDistrict=ON&locality=Toronto&addressLine=20%Duncan%Street&key=
          streetmapsString = URI.encode('http://www.mapquestapi.com/geocoding/v1/address?key=Fmjtd|luurn1u8l9%2Cbw%3Do5-9wyx0a&outFormat=json&location=' + e.location)

          begin
            puts streetmapsString
            coords = JSON.parse(open(streetmapsString).read)
            unless coords == nil || coords['results'].empty?
              puts 'entering street maps'
              coordsSpec = coords['results'][0]['locations'][0]['latLng']
              e.latitude, e.longitude = coordsSpec['lat'], coordsSpec['lng']
            end
          rescue
          end

        end

        # check if no events, if so then geocode. of if previous geocode gave wonky results or if similair to last event, to get variation. or if currently nil
        if Event.last == nil || !( e.latitude.to_i - 43 >= 0 && e.latitude.to_i - 43 <= 3 ) || Event.last.latitude == e.latitude || Event.last.latitude == e.latitude || e.latitude == nil
          # http://dev.virtualearth.net/REST/v1/Locations?CountryRegion=CA&adminDistrict=ON&locality=Toronto&addressLine=20%Duncan%Street&key=
          locationSplit = e.location.split(',')[0]
          mapsUrl = "http://dev.virtualearth.net/REST/v1/Locations?CountryRegion=CA&adminDistrict=ON&locality=Toronto&addressLine=" + locationSplit + "&key=" + Figaro.env.maps_key

          begin
            coords = JSON.parse(open(URI.encode(mapsUrl)).read)
            unless coords == nil || coords['resourceSets']['resources'].empty?
              puts 'enter bing maps'
              coordsSpec = coords['resourceSets']['resources'][0]['point']['coordinates']
              e.latitude, e.longitude = coordsSpec[0], coordsSpec[1]
            end
          rescue
          end

        end

        if Event.last == nil || !( e.latitude.to_i - 43 >= 0 && e.latitude.to_i - 43 <= 3 ) || Event.last.latitude == e.latitude || e.latitude == nil
          here_key = Figaro.env.here_key
          here_secret = Figaro.env.here_secret
          string = "http://geocoder.cit.api.here.com/6.2/geocode.json?app_id=" + here_key + "&app_code=" + here_secret +"&gen=8&searchtext=" + e.location.gsub(' ', '+').gsub(',', '')          
          begin
            coords = JSON.parse((open(string)).read)
          rescue
            string = URI.encode(string)
            coords = JSON.parse((open(string)).read)
          end
          unless coords == nil || coords["Response"]["View"].length == 0
            puts 'enter geocoder.cit'
            coords = coords["Response"]["View"][0]["Result"][0]["Location"]["DisplayPosition"]
            e.latitude, e.longitude = coords['Latitude'], coords['Longitude']
          end
        end

        if Event.last == nil || !( e.latitude.to_i - 43 >= 0 && e.latitude.to_i - 43 <= 3 ) || Event.last.latitude == e.latitude || e.latitude == nil
          string = "http://api.tiles.mapbox.com/v4/geocode/mapbox.places/"+e.location.gsub('-','').gsub(',','').gsub('(','').gsub(')','').gsub(' ', '+')+".json?access_token=pk.eyJ1IjoicmFrc29uaWJzIiwiYSI6IjZ0TFFlUEUifQ._wLBBR-FcaQuIK-tnfU7-w"          
          begin
            coords = JSON.parse((open(string)).read)
            unless coords == nil || coords['features'] == []
              puts 'enter mapbox'
              e.latitude, e.longitude = coords['features'][0]['center'][1], coords['features'][0]['center'][0]
            end
          rescue
          end
        end
        
        if Event.last == nil || !( e.latitude.to_i - 43 >= 0 && e.latitude.to_i - 43 <= 3 ) || Event.last.latitude == e.latitude || e.latitude == nil
          string = "https://api.geocod.io/v1/geocode?q=" + e.location.gsub('-','').gsub(',','').gsub('(','').gsub(')','').gsub(' ', '+') + "&api_key=cf88885cb459801b5a1b52aac3c89531b584934"          
          begin
            coords = JSON.parse((open(string)).read)
            unless coords == nil || coords['results'] == []
              puts 'enter geocoder'
              e.latitude, e.longitude = coords['results'][0]['location']['lat'], coords['results'][0]['location']['lng']
            end
          rescue
          end
        end
        
        

      end
      
      e.uuid = SecureRandom.uuid

      e.save!
    end
    writeToFile(arrEvents)
  end

  def self.createEvents
    arrEvents = Event.getdata
    Event.callCreation(arrEvents)
  end

  def self.createEventsTwo
     arrEvents = Event.getdata_two
     Event.callCreation(arrEvents)
  end

  def self.getdata
  	 return [self.justshows,
             self.eventbrite,
             self.eventful,
             self.meetup,
             self.blogto,
             self.cityhall,
             self.torontocom
  	].flatten
  end

  def self.getdata_two
    return [self.nowmagazine,
            self.elmcity
          ].flatten
  end

  def self.cityhall
    puts 'Running cityhall'
  	events = []
  	data = Nokogiri::HTML(open("http://wx.toronto.ca/festevents.nsf/tpaview?readviewentries")).xpath("//viewentry")
    count = 0

    data.each do |val|

      dayOn = val.xpath("//entrydata[@name='DateBeginShow']")[count].text
      dayEnd = val.xpath("//entrydata[@name='DateEndShow']")[count].text

      #if it is on today or in eight days, or today is inbetween its start and end date
      if ( Date.parse(dayOn) >= Date.today && Date.parse(dayOn) <= ( Date.today + 8 ) ) || ( Date.today >= Date.parse(dayOn) && Date.today <= Date.parse(dayEnd) )
        location = val.xpath("//entrydata[@name='Location']")[count].text
        location = location == "" || location == nil ?  "Toronto, Canada" : location + ', Toronto, Canada'

        price = val.xpath("//entrydata[@name='Admission']")[count].text == "" ? "Price not listed" : val.xpath("//entrydata[@name='Admission']")[count].text
        if price[/ - /]
          price = price[/\s\$\d+/][/\d+/]
          price = price[/\d+/]
        else
          price = price == "Free" || price == "Price not listed" ? price : price[/\d+/]
        end

        categoryList = val.xpath("//entrydata[@name='CategoryList']")[count].text
        # annoying regex to check for categoryList
        categoryList = if categoryList == nil 
                          ["Misc"]
                        else
                          categoryList.split(/([A-Z]+[a-z]*\s*[a-z]*)/).reject! { |c| c.empty? || c == "/"}
                        end

        categoryList = ["Misc"] if categoryList == nil || categoryList == ""

        timeStart = val.xpath("//entrydata[@name='TimeBegin']")[count].text == "" || val.xpath("//entrydata[@name='TimeBegin']")[count].text == nil || val.xpath("//entrydata[@name='TimeBegin']")[count].text == ': ' ? "Time not listed" : Time.parse(val.xpath("//entrydata[@name='TimeBegin']")[count].text).strftime("%I:%M %p")
        timeEnd = val.xpath("//entrydata[@name='TimeEnd']")[count].text == "" || val.xpath("//entrydata[@name='TimeBegin']")[count].text == nil || val.xpath("//entrydata[@name='TimeBegin']")[count].text == ': ' ? "Time not listed" : Time.parse(val.xpath("//entrydata[@name='TimeEnd']")[count].text).strftime("%I:%M %p")

        url = val.xpath("//entrydata[@name='EventURL']")[count].text == "" || val.xpath("//entrydata[@name='EventURL']")[count].text == nil ? "No url listed" : val.xpath("//entrydata[@name='EventURL']")[count].text

        image = val.xpath("//entrydata[@name='Image']")[count].text == "" || val.xpath("//entrydata[@name='Image']")[count].text == nil ? "http://i.imgur.com/ixz8pZT.png?1" : val.xpath("//entrydata[@name='Image']")[count].text

        # day start and end used for ranges
        dayOn = dayOn + " " + timeStart
        dayEnd = dayOn + ' ' + timeEnd

        name =  val.xpath("//entrydata[@name='EventName']")[count].text

        desc = val.xpath("//entrydata[@name='LongDesc']")[count].text

        events.push({name: name, 
                    url: url,
                    location: location,
                    price: price,
                    dayOn: dayOn,
                    dayEnd: dayEnd,
                    desc: desc,
                    categoryList: categoryList,
                    source: "City Hall",
                    image: image
                  })
      end

      count += 1
    end

    return events
  end

  def self.nowmagazine
    puts 'Running nowmagazine'
    # http://nowtoronto.com/sesarch/event/all/
    eventsAll = Scraper::NowMagazine.get_events
  end

  def self.eventbrite
    # since this will only be run every sun and wed, just get events. Reason this is run less is because only have small api limit. Wonder if eventful is still pay what you have
    # http://www.eventbrite.com/json/event_search?app_key=GUBRP2USZMDRRVPPSF&city=Toronto&date=2014-11-05%202014-11-10&page=2 -> testing
    puts 'Running eventbrite'
    dateToday = Date.today#.strftime("%Y-%m-%d")
    next7days = (dateToday+7).to_s
    string = "http://www.eventbrite.com/json/event_search?app_key=GUBRP2USZMDRRVPPSF&city=Toronto&date="+dateToday.to_s+"%20"+next7days+'&max=100'
    data = JSON.parse((open(string)).read)
    totalEvents = data['events'][0]['summary']['total_items']
    dataAll = {}
    eventAll = []
    eventCount = 1
    pageCount = 1

    while eventCount <= totalEvents
      dataForPage = JSON.parse((open(string+'&page='+pageCount.to_s)).read)['events']
      eventCount += 100
      pageCount += 1
      dataForPage[1..-1].each do |event|
        name = event['event']["title"]
        timeStart = event['event']["start_date"]
        timeEnd = event['event']["end_date"]
        price = event['event']["tickets"][0]["ticket"]["price"]
        price = price == "0.00" || price == nil ? "Free" : price
        location = event['event']["venue"]["address"] + event['event']["venue"]["address_2"]
        location = location == "" || location == nil ? "No address listed" : location + ", Toronto, Canada"
        url = event['event']["url"]
        desc = event['event']["description"] || "No description"
        categoryList = Event.findCats(desc)
        categoryList = ["Misc"] if categoryList == nil || categoryList == ""
        image = event['event']['logo'] != nil || event['event']['logo'] != "" ? event['event']['logo'] : "http://i.imgur.com/ixz8pZT.png?1"
        desc = ActionView::Base.full_sanitizer.sanitize(desc).gsub("\n",'').gsub("\t", "").gsub("\r","").strip

        eventAll.push({
          name: name,
          url: url,
          location: location, 
          price: price,
          dayOn: timeStart,
          dayEnd: timeEnd,
          desc: desc,
          categoryList: categoryList,
          source: "Eventbrite",
          image: image
        })
      end
    end
    return eventAll
  end

  def self.eventful
    # very similiar to eventful, can be one method
    # http://api.eventful.com/json/events/search?app_key=hSXmLwVD99qfGPBs&location=Toronto&t=Next+7+days&page_size=100&page_number=2
    puts 'Running eventful'
    string = "http://api.eventful.com/json/events/search?app_key=hSXmLwVD99qfGPBs&location=Toronto&t=Next+7+days&page_size=100"   
    data = JSON.parse((open(string)).read)
    totalEvents = data['total_items'].to_i
    eventAll = []
    eventCount = 1
    pageCount = 1

    while eventCount <= totalEvents
      dataForPage = JSON.parse((open(string+'&page_number='+pageCount.to_s)).read)['events']['event']
      eventCount += 100
      pageCount += 1

      dataForPage.each do |event|
        name = event["title"]
        timeStart = event["start_time"]
        timeEnd = event["stop_time"] || "No end time specified"
        price = 'Check listing url!'
        location = event["venue_address"]
        location = location == "" || location == nil ? "No address listed" : location + ", Toronto, Canada"
        url = event["url"]
        desc = event["description"] || "No description"
        desc = "No description" if desc.strip == "" 
        categoryList = Event.findCats(desc)
        categoryList = ["Misc"] if categoryList == nil || categoryList == ""
        longitude = event["longitude"]
        latitude = event['latitude']
        image = "http://i.imgur.com/ixz8pZT.png?1"
        desc = ActionView::Base.full_sanitizer.sanitize(desc).gsub("\n",'').gsub("\t", "").gsub("\r","").strip

        eventAll.push({
          name: name,
          url: url,
          location: location, 
          price: price,
          dayOn: timeStart,
          dayEnd: timeEnd,
          desc: desc,
          categoryList: categoryList,
          source: "Eventful",
          longitude: longitude,
          latitude: latitude,
          image: image
        })

      end
    end

    return eventAll
  end

  def self.meetup 
    puts 'Running meetup'
    string =  "https://api.meetup.com/2/open_events?&sign=true&city=Toronto&country=ca&time=0d,7d&status=upcoming&key=7b794c3657477db4e107a7e366f7b5f"
    data = JSON.parse((open(string)).read)
    totalEvents = data['meta']['total_count']
    dataAll = {}
    eventAll = []
    eventCount = 1
    pageCount = 0

    while eventCount <= totalEvents
      dataForPage = JSON.parse((open(string+'&offset='+pageCount.to_s)).read)['results']
      eventCount += data['meta']['count']
      pageCount += 1

      dataForPage.each do |event|
        name = event["name"]
        name = name == nil || name == "" ? event["group"]["name"] : name
        time = Time.at(event["time"]/1000).to_datetime
        price = event["fee"] != nil ? event["fee"]["amount"] : 0
        price = price == 0 || price == nil || price == "0" ? "Free" : price
        location = event["venue"] == nil ? "" : event["venue"]["address_1"]
        location = location == "" || location == nil ? "No address listed" : location + ", Toronto, Canada"
        url = event["event_url"]
        desc = event["description"] || "No description"
        categoryList = Event.findCats(desc)
        categoryList = ["Misc"] if categoryList == nil || categoryList == ""
        latitude = event["venue"] == nil ? nil : event['venue']['lat']
        longitude = event["venue"] == nil ? nil :event['venue']['lon']
        image = "http://i.imgur.com/ixz8pZT.png?1"
        desc = ActionView::Base.full_sanitizer.sanitize(desc).gsub("\n",'').gsub("\t", "").gsub("\r","").strip

        eventAll.push({
          name: name,
          url: url,
          location: location, 
          price: price,
          dayOn: time,
          dayEnd: time + 3.hours,
          desc: desc,
          categoryList: categoryList,
          source: "Meetup",
          latitude: latitude,
          longitude: longitude,
          image: image
        })
      end
    end

    return eventAll
  end

  def self.club_crawler_create
    arrEvents = Event.club_crawlers
    Event.callCreation(arrEvents)
  end

  def self.justshows
    puts 'Running justshows'
    # http://justshows.com/toronto/?p=2
    string = "http://justshows.com/toronto/"
    dataEvents = Nokogiri::HTML(open(string))
    totalPages = dataEvents.css('ul.pages').css('li.different-page')[-1].text().to_i
    eventAll = []
    pageCount = 1

    while pageCount < totalPages
      pageEvents = Nokogiri::HTML(open(string+'?p='+pageCount.to_s)).css('ul.shows li')

      pageEvents.each do |event|
        dayTimeStart = event.css("strong.day").text + " " + Time.parse(event.css("span.time").text).strftime("%I:%M %p")
        price = event.css("span.venue-meta").text[/\$\d+(\.\d+\s)?(-$\d+\.\d+)?[^All]+[\d+]/]
        price = price != nil || price != "Free" ? price : 'Free'
        price = 'Free' if price == nil
        name = event.css("strong.summary").text
        location = event.css("strong.location").text + ', Toronto, Canada'
        url = "http://justshows.com" + event.css('a').map{|a| a['href']}[0]
        description = "Music"
        image = "http://i.imgur.com/ixz8pZT.png?1"

        eventAll.push({
          name: name,
          url: url,
          location: location,
          price: price,
          dayOn: dayTimeStart,
          dayEnd: Time.parse(dayTimeStart) + 4.hours,
          desc: description,
          categoryList: ["Music"],
          source: "Just Shows",
          image: image
        })
      end

      pageCount += 1
    end

    return eventAll
  end

  def self.blogto
    puts 'Running blogto'
    # http://www.blogto.com/events/?date=2014-11-11&status=started-today
    today = Date.today
    todaystr = today.strftime("%Y-%m-%d")
    string = "http://www.blogto.com/events/?date="+todaystr+"&status=started-today"
    sevenDays = (today+7).strftime("%Y-%m-%d")
    dayCount = 0
    dataEvents = Nokogiri::HTML(open(string)).css('.events-list').css('.event-item')
    allEvents = []

    while dayCount <= 7
      string = "http://www.blogto.com/events/?date="+todaystr+"&status=started-today"
      dataEvents = Nokogiri::HTML(open(string)).css('.events-list').css('.events-item')

      dataEvents.each do |event|
        url = 'http://blogto.com' + event.css('.event-name').css('a')[0]['href']
        name = event.css('.event-name').text()
        location = event.css('.event-address').text()
        location = location== "" || location == nil ? 'Toronto, Canada' : location + ', Toronto, Canada'
        dayTime = todaystr + " " + event.css('info-eventtime').text()
        descIncomplete = event.css('.event-summary').text()
        categoryList = Event.findCats(descIncomplete)
        categoryList = ["Misc"] if categoryList == nil || categoryList == ""
        image = if !event.css('.poster').css('img').empty?
          event.css('.poster').css('img')[0]['src']
        else
          "http://i.imgur.com/ixz8pZT.png?1"
        end

        allEvents.push({
          name: name,
          url: url,
          location: location, 
          price: 'Check listing url!',
          dayOn: dayTime,
          dayEnd: "No end time specified",
          desc: descIncomplete,
          categoryList: categoryList,
          source: "Blog.to",
          image: image
        })
      end

      dayCount += 1
      todaystr = (today+dayCount).strftime("%Y-%m-%d")
    end
    return allEvents

  end

  def self.torontocom
    puts 'Running torontocom'
    # http://www.toronto.com/events/?date=2014-11-07&enddate=2014-11-14&
    # run with meetup and sort every sun and wed night for next 7 days? I think nine is better!
    today = Date.today
    todaystr = today.strftime("%Y-%m-%d")
    sevenDays = (today+7).strftime("%Y-%m-%d")
    pageCount = 1
    eventAll = []
    string = "http://www.toronto.com/events/?date="+todaystr+"&enddate="+sevenDays+"&pagination="+pageCount.to_s
    numPages = Nokogiri::HTML(open(string)).css('.pager').css('a')[-1].text().to_i

    while pageCount < numPages
      string = "http://www.toronto.com/events/?date="+todaystr+"&enddate="+sevenDays+"&pagination="+pageCount.to_s
      dataEvents =  Nokogiri::HTML(open(string)).css('.listing').css('li')

      dataEvents.each do |event|
        url = event.css('a').map{|a| a["href"]}[0]
        name = event.css('h2')[0].text()
        desc = event.css('p').text()
        matchReg = event.css('.meta').text().scan(/[A-Z][a-z]+\s\d+\,\s\d+/)
        dayStart = matchReg[0] || "No start time specified"
        dayEnd = matchReg[1] || "No end time specified"
        location = event.css('.meta').text()[/Location:\s[A-z\s\']*/]
        location = location== "" || location == nil ? 'Toronto, Canada' : location[1..-1].sub(/\s+\Z/, "") + ', Toronto, Canada'
        # sub here used to remove whitespace
        location = location[9..-1].sub(/\s+\Z/, "") + ', Toronto, Canada'
        categoryList = Event.findCats(desc)
        categoryList = ["Misc"] if categoryList == nil || categoryList == ""
        image = if !event.css('.img-holder').css('img').empty?
          event.css('.img-holder').css('img')[0]['src']
        else
          "http://i.imgur.com/ixz8pZT.png?1"
        end

        eventAll.push({
          name: name,
          url: url,
          location: location,
          price: 'Check listing url!',
          dayOn: dayStart,
          dayEnd: dayEnd,
          desc: desc,
          categoryList: categoryList,
          source: "Toronto.com",
          image: image
        })
      end
      pageCount += 1
    end

    return eventAll
  end

  def self.club_crawlers
    puts 'Running club_crawlers'
    eventAll = Scraper::NowMagazine.club_events
  end

  def self.elmcity
    puts 'Running elmcity'
    string =  "http://elmcity.cloudapp.net/Toronto/json"
    data = JSON.parse((open(string)).read)
    eventAll = []
    data.each do |event|
      name = event["title"]
      dayOn = DateTime.parse(event['dtstart']).to_time
      dayEnd = DateTime.parse(event['dtend']).to_time
      url = event["url"]
      source = event["source"]
      location = event["location"]
      location = location == "" || location == nil ? "No address listed" : location + ", Toronto, Canada"
      desc = event["description"] || "No description"
      desc = ActionView::Base.full_sanitizer.sanitize(desc).gsub("\n",'').gsub("\t", "").gsub("\r","").strip
      categoryList = event['categories'].split(',')
      categoryList = ["Misc"] if categoryList == nil || categoryList == "" || categoryList == " "
      image = "http://i.imgur.com/ixz8pZT.png?1"
      latitude = event['lat']
      longitude = event['lon']

      eventAll.push({
        name: name,
        url: url,
        location: location, 
        price: "Price not listed",
        dayOn: dayOn,
        dayEnd: dayEnd,
        desc: desc,
        categoryList: categoryList,
        image: image,
        source: "Elmcity",
        latitude: latitude,
        longitude: longitude
      })
    end

    return eventAll
  end

  def self.findCats(desc)
    catList = []
    catList << "Music" if desc[/music/i] || desc[/jam/i] || desc[/concert/i] || desc[/band/i] || desc[/songs/i] || desc[/vocal/i] || desc[/singer/i] || desc[/songwriter/i]
    catList << "Seasonal" if desc[/holiday/i] || desc[/christmas/i] || desc[/hannu/i] || desc[/seasonal/i] || desc[/festive/i]
    catList << "Cultured" if desc[/reading/i] || desc[/\sart/i] || desc[/museum/i] || desc[/gallery/i] || desc[/documentary/i]
    catList << "Learn" if desc[/learn/i] || desc[/knowledge/i] || desc[/conference/i] || desc[/reading/i] || desc[/university/i] || desc[/school/i] || desc[/class/i]
    catList << "Investing" if desc[/invest/i] || desc[/business/i] || desc[/spend/i] || desc[/network/i] || desc[/money/i] 
    catList << "Sport" if desc[/sport/i] || desc[/exercise/i] || desc[/yoga/i] || desc[/basketball/i] || desc[/hockey/i] || desc[/soccer/i]
    catList << "Geek" if desc[/learn/i] || desc[/conference/i] || desc[/tech/i] || desc[/computer/i] || desc[/developer/i] || desc[/programmer/i] || desc[/wearable/i] || desc[/printer/i]
    catList << "Outdoor" if desc[/park/i] || desc[/outdoors/i] || desc[/forest/i] || desc[/skating/i]
    catList << "Good" if desc[/benefits/i] || desc[/gala/i] || desc[/charity/i] || desc[/fundraising/i]
    catList << "Party" if desc[/bash/i] || desc[/party/i] || desc[/alcohol/i] || desc[/dancing/i]
    catList << "Watch" if desc[/show/i] || desc[/watch/i] || desc[/movie/i] || desc[/film/i]
    catList << "Laugh" if desc[/comedy/i] || desc[/funny/i] || desc[/improv/i] || desc[/comedic/i]
    catList << "Religion" if desc[/religious/i] || desc[/religion/i] || desc[/jesus/i] 
    catList << "Food" if desc[/food/i] || desc[/barbeque/i] || desc[/dinner/i] || desc[/lunch/i] || desc[/breakfast/i]
    catList = catList != [] ? catList : ["Misc"]
    catList
  end
end

require 'open-uri'
require 'nokogiri'
require 'time'

class Event < ActiveRecord::Base
	geocoded_by :location
	after_validation :geocode if :location_changed?

  def self.getdata
  	[self.cityhall
  	]
  end
  # (name:k, time:source[k][0], price:source[k][1], 
    # location:source[k][2], category:source[k][3], 
    # link:source[k][4], feeling: "None")

  def self.cityhall
    # category split based on each new capital
  	events = []
  	data = Nokogiri::HTML(open("http://wx.toronto.ca/festevents.nsf/tpaview?readviewentries")).xpath("//viewentry")
    count = 0
    data.each do |val|
      location = val.xpath("//entrydata[@name='Location']")[count].text+ ", Toronto, ON, Canada"

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
                        "Misc" 
                      else
                        categoryList.split(/([A-Z]+[a-z]*\s*[a-z]*)/).reject! { |c| c.empty? || c == "/"}
                      end

      timeStart = val.xpath("//entrydata[@name='TimeBegin']")[count].text == "" || val.xpath("//entrydata[@name='TimeBegin']")[count].text == nil || val.xpath("//entrydata[@name='TimeBegin']")[count].text == ': ' ? "Time not listed" : Time.parse(val.xpath("//entrydata[@name='TimeBegin']")[count].text).strftime("%I:%M %p")
      timeEnd = val.xpath("//entrydata[@name='TimeEnd']")[count].text == "" || val.xpath("//entrydata[@name='TimeBegin']")[count].text == nil || val.xpath("//entrydata[@name='TimeBegin']")[count].text == ': ' ? "Time not listed" : Time.parse(val.xpath("//entrydata[@name='TimeEnd']")[count].text).strftime("%I:%M %p")

      url = val.xpath("//entrydata[@name='EventURL']")[count].text == "" || val.xpath("//entrydata[@name='EventURL']")[count].text == nil ? "No url listed" : val.xpath("//entrydata[@name='EventURL']")[count].text
      # day start and end used for ranges
      events.push({name: val.xpath("//entrydata[@name='EventName']")[count].text, 
                  price: price,
                  dayOn: val.xpath("//entrydata[@name='DateBeginShow']")[count].text,
                  dayEnd: val.xpath("//entrydata[@name='DateEndShow']")[count].text,
                  startTime: timeStart,
                  endTime: timeEnd,
                  location: location,
                  desc: val.xpath("//entrydata[@name='LongDesc']")[count].text,
                  eventUrl: url,
                  categories: categoryList
                })
      count += 1
    end

    return events
  end

  def self.nowmagazine
    # reg expression for location has to watch for special chars and suit numbers
    #categories seem talk(talk, symposium, screening, lecture, speak, discuss), music(music) theatre(performances), reading(reading, novel), comedy, seasonal(festiv,holiday, carol, christmas), party(party), charity(fundrais, auction), miscelianous (everything else) 
    # for now standard category being event subgenre because not sure what events categories want yet
    events = []
    data = Nokogiri::HTML(open("http://www.nowtoronto.com/news/listings/"))
    .css(".listing-entry")
    # data is all the options, but not the actual day it is on .css("div[class^='List-Body']") for the listing entry is teh day
    # know that all listing header has bunch of list events underneath them.
    data[0...1].each do |listing|
      dateForListing = listing.css('.listing-header').text
      listing.css('.subgenre').each do |genreDetail|
        genreDetail.css('.List-Body').each do |listingDetail|

          price = listingDetail.text[/\$\w+|[fF]ree|Donation/] || 'Price not listed'
          location = listingDetail.text[/\d+([A-Z]*)?\s[A-Z][a-z]+('[a-z])?(\s[A-Z][a-z]*)*,/] || 'Address not listed'
          time = listingDetail.text[/([0-9]+:)?[0-9]+\s(a|p)m(-[0-9]+\s(a|p)m)?/] != nil ? Time.parse(time=listingDetail.text[/([0-9]+:)?[0-9]+\s(a|p)m(-[0-9]+\s(a|p)m)?/]).strftime("%I:%M %p") : 'Time not listed'
          url = listingDetail.text[/[A-Za-z\-\\0-9]*(\.)?[A-Za-z\-\\0-9]+\.(ca|com)\./].try(:[], 0...-1) || 'Url not listed'
          
          events.push({
            name: listingDetail.css('.List-Name').text,
            dateOn: dateForListing,
            desc: listingDetail.text,
            price: price,
            location: location,
            category: genreDetail.css('.medgrey-txt').text,
            time: time,
            url: url
          })
        end
      end
      return events
    end
  end

  def self.eventbrite
    # since this will only be run every sun and wed, just get events. Reason this is run less is because only have small api limit. Wonder if eventful is still pay what you have
    # http://www.eventbrite.com/json/event_search?app_key=GUBRP2USZMDRRVPPSF&city=Toronto&date=2014-11-05%202014-11-10&page=2 -> testing
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
      dataForPage = JSON.parse((open(string+'&page='+pageCount.to_s)).read)
      dataAll['page'+pageCount.to_s] = dataForPage
      eventCount += 100
      pageCount += 1

      dataForPage.each do |event|
        name = event["event"]["title"]
        timeStart = event["event"]["start_date"] #Time.parse(event["event"]["start_date"][/\d+:\d+:\d+/]).strftime("%I:%M %p")
        timeEnd = event["event"]["end_date"]
        price = event["event"]["tickets"][0]["ticket"]["price"]
        price = price == "0.00" || price == nil ? "Free" : price
        location = event["event"]["venue"]["address"] + event["event"]["venue"]["address_2"]
        location = location == "" || location == nil ? "No address listed" : location + ", Toronto, ON, Canada"
        url = event["event"]["url"]
        desc = event["event"]["description"]
        eventAll.push({
          name: name,
          dayOn: timeStart,
          dayEnd: timeEnd,
          price: price,
          location: location, 
          url: url,
          desc: desc
        })
      end
    end

    return eventAll
  end

  def self.eventful
    # very similiar to eventful, can be one method
    # http://api.eventful.com/json/events/search?app_key=hSXmLwVD99qfGPBs&location=Toronto&t=Next+7+days&page_size=100&page_number=2
    string = "http://api.eventful.com/json/events/search?app_key=hSXmLwVD99qfGPBs&location=Toronto&t=Next+7+days&page_size=100"
    
    data = JSON.parse((open(string)).read)

    totalEvents = data['events'][0]['summary']['total_items']

    dataAll = {}

    eventAll = []

    eventCount = 1
    pageCount = 1

    while eventCount <= totalEvents
      dataForPage = JSON.parse((open(string+'&page_number='+pageCount.to_s)).read)
      dataAll['page'+pageCount.to_s] = dataForPage
      eventCount += 100
      pageCount += 1

      dataForPage.each do |event|
        # might have to do event[count or something]
        name = event["event"]["title"]
        timeStart = event["event"]["start_time"] #Time.parse(event["event"]["start_date"][/\d+:\d+:\d+/]).strftime("%I:%M %p")
        timeEnd = event["event"]["stop_time"]
        # price = event["event"]["tickets"][0]["ticket"]["price"]
        # price will have to be reg exp searching through description:()
        price = price == "0.00" || price == nil ? "Free" : price
        location = event["event"]["venue_address"]
        location = location == "" || location == nil ? "No address listed" : location + ", Toronto, ON, Canada"
        url = event["event"]["url"]
        desc = event["event"]["description"]
        eventAll.push({
          name: name,
          dayOn: timeStart,
          dayEnd: timeEnd,
          price: price,
          location: location, 
          url: url,
          desc: desc
        })
      end
    end

    return eventAll
  end

  def self.meetup 
    string =  "https://api.meetup.com/2/open_events?&sign=true&city=Toronto&country=ca&time=0d,7d&status=upcoming&key=7b794c3657477db4e107a7e366f7b5f"
    data = JSON.parse((open(string)).read)
    totalEvents = data['meta']['total_count']
    dataAll = {}
    eventAll = []
    eventCount = 1
    pageCount = 0

    while eventCount <= totalEvents
      dataForPage = JSON.parse((open(string+'&offset='+pageCount.to_s)).read)
      dataAll['page'+pageCount.to_s] = dataForPage
      eventCount += data['meta']['count']
      pageCount += 1

      dataForPage.each do |event|
        # might have to do event[count or something]
        name = event["name"]
        name = name == nil || name == "" ? event["group"]["name"] : name
        time = Time.at(event["time"]/1000).strftime("%I:%M %p")
        price = event["fee"]["amount"]
        # price will have to be reg exp searching through description:()
        price = price == 0 || price == nil || price == "0" ? "Free" : price
        location = event["venue"]["address_1"]
        location = location == "" || location == nil ? "No address listed" : location + ", Toronto, ON, Canada"
        url = event["event_url"]
        desc = event["description"]
        eventAll.push({
          name: name,
          dayOn: time,
          price: price,
          location: location, 
          url: url,
          desc: desc
        })
      end
    end

    return eventAll
  end

  def self.justshows
    # http://feeds.justshows.net/rss/toronto/
    # ugh! can't use rss feed because no prices :()
    string = "http://feeds.justshows.net/rss/toronto/"
    dataEvents = Nokogiri::HTML(open(string)).xpath('//item')
    # puts dataEvents
    eventAll = []
    # doubling on events (even tripling), need to not push if any object has name value as such
    #  probably happening because on event I am looking for all titles, not just unique to date.
    #  might need a count
    puts dataEvents
    dataEvents.each do |event|
      name = event.xpath('//title')[/\s[A-Z][a-z]+/]
      dateOn = event.xpath('//title')[/[A-Z][a-z]+\s\d+\,\s\d+/]
      url = event.xpath('//url')
      description = event.xpath('//description')
      unless eventAll.any? {|c| c.name == name}
        eventAll.push({
          name: name,
          dateOn: dateOn,
          url: url

          })
      end
      
    end
  end

end

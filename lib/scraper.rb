include Capybara::DSL

module Scraper
  class NowMagazine

    def self.get_events
      eventAll = []
      #  eventually each page needs to be changed by click so keep runnnnig that click until count is ten
      #  someties node attachment error. so when that happens need to wait and rerun
      page = visit('/')
      count = 0
      while count <= 100
        page.all(:css, '.event_result').each do |element|
          name = element.find('.event_title').text()
          splitedDate = element.find('.event_date').text().split('-')
          dayOn = splitedDate[0]
          dayEnd = splitedDate[1] || splitedDate[0]
          url = element.find('h4.event_title a')[:href]
          location = element.all(:css, '.event_info a')[1].text() + ', Toronto, ON, Canada'
          desc = element.find('.description').text()
          price = desc[/\$\d+/] || "Free"
          categories = element.find('.cats span').text().split(/[,\/]/).map{|c| c.sub(' ', '')}
          eventAll.push({
              name: name,
              dayOn: dayOn,
              dayEnd: dayEnd,
              url: url,
              location: location,
              desc: desc,
              categoryList: categories,
              price: price
            })
        end
        page = page.find('.next').click()
        count += 1
      end
      return eventAll
    end
  end
end
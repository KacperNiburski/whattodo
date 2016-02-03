json.meta do
  json.eventCount @eventsMatched.count
end
json.events @eventsMatched do |event, value|
  json.score value[0]
  json.ruby_id value[1].id
  json.uuid value[1].uuid
  json.name value[1].name
  json.approved value[1].approved
  json.location value[1].location
  json.price value[1].price
  if value[1].dayOn == "No start time specified" && value[1].dayEnd == "No end time specified"
    if value[1].source == 'Self'
      json.dayOn (DateTime.parse(value[1].dayOn)+5.hours).to_i
      json.dayEnd (DateTime.parse(value[1].dayOn)+5.hours).to_i
    else
      json.dayOn (DateTime.parse(value[1].dayOn)+5.hours).to_i
      json.dayEnd (DateTime.parse(value[1].dayEnd)+5.hours).to_i
    end
  else
    json.dayOn (DateTime.parse(value[1].dayOn)+5.hours).to_i
    json.dayEnd (DateTime.parse(value[1].dayEnd)+5.hours).to_i
  end
  json.latitude value[1].latitude
  json.longitude value[1].longitude
  json.url value[1].url
  json.image value[1].image
  json.desc value[1].desc
  json.categoryList value[1].categoryList
  json.source value[1].source
  json.created_at value[1].created_at.to_i
  json.updated_at value[1].updated_at.to_i
end
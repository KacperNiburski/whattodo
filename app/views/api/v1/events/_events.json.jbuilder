json.meta do
  json.eventCount events.count
end
json.events events do |event|
  json.ruby_id event.id
  json.uuid event.uuid
  json.name event.name
  json.location event.location
  json.price event.price
  if event.dayOn == "No start time specified" && event.dayEnd == "No end time specified"
    if event.dayOn.length < 10
      json.dayOn event.dayOn
      json.dayEnd event.dayEnd
    else
      json.dayOn Time.parse(event.dayOn).to_i
      json.dayEnd Time.parse(event.dayEnd).to_i
    end
  else
    json.dayOn event.dayOn
    json.dayEnd event.dayEnd
  end
  json.latitude event.latitude
  json.longitude event.longitude
  json.url event.url
  json.image event.image
  json.desc event.desc
  json.categoryList event.categoryList
  json.source event.source
  json.created_at event.created_at.to_i
  json.updated_at event.updated_at.to_i
end
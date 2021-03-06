json.meta do
  json.eventCount events.count
end
json.events events do |event|
  json.ruby_id event.id
  json.uuid event.uuid
  json.name event.name
  json.approved event.approved
  json.location event.location
  json.price event.price
  if event.dayOn == "No start time specified" && event.dayEnd == "No end time specified"
    if event.source == 'Self'
      json.dayOn event.dayOn
      json.dayEnd event.dayOn
    else
      json.dayOn event.dayOn
      json.dayEnd event.dayEnd
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
  json.created_at event.created_at
  json.updated_at event.updated_at
end
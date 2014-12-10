json.meta do
  json.eventCount events.count
end
json.events events do |event|
  json.ruby_id event.id
  json.uuid SecureRandom.uuid 
  json.name event.name
  json.location event.location
  json.price event.price
  if event.dayOn.length < 10
    json.dayOn event.dayOn
    json.dayOn event.dayEnd
  else
    json.dayOn Time.parse(event.dayOn).to_i
    json.dayEnd Time.parse(event.dayOn).to_i
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
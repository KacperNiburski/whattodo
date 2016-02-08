json.meta do
  json.eventCount @eventsMatched.count
end
json.events @eventsMatched.each do |value|
  json.score value[0]
  jsonString = JSON.parse(value[1])
  json.ruby_id jsonString['id']
  json.uuid jsonString['uuid']
  json.name jsonString['name']
  json.approved jsonString['approved']
  json.location jsonString['location']
  json.price jsonString['price']
  if jsonString['dayOn'] == "No start time specified" && jsonString['dayEnd'] == "No end time specified"
    json.dayOn jsonString['dayOn'])
    json.dayEnd jsonString['dayEnd'])
  else
    json.dayOn jsonString['dayOn'])
    json.dayEnd jsonString['dayEnd'])
  end
  json.latitude jsonString['latitude']
  json.longitude jsonString['longitude']
  json.url jsonString['url']
  json.image jsonString['image']
  json.desc jsonString['desc']
  json.categoryList jsonString['categoryList']
  json.source jsonString['source']
  json.created_at jsonString['created_at.to_i']
  json.updated_at jsonString['updated_at.to_i']
end
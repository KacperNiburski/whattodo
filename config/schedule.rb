every :sunday, :at=> "04:00am" do
	rake "get_events:get_events"
end

every :monday, :at=> "06:00am" do
  rake "get_events_two:get_events_two"
end

every :day, :at => "08:30am" do
  rake "get_clubs:get_clubs"
end

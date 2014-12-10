every :wednesday, :at=> "04:00am" do
	rake "get_events:get_events"
end

every :day, :at => "05:00am" do
  rake "get_clubs:get_clubs"
end

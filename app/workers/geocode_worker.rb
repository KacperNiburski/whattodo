class GeocodeWorker
  include Sidekiq::Worker

  def perform(event_id)
    console.log('geocoding')
    event = Event.find(event_id)
    Event.geocodeEvent(event_id)
    sleep 1
  end
end
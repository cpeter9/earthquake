require 'httparty'

current_karma = 0
max_karma = 0

SCHEDULER.every '2s' do
  last_karma = current_karma
  
  data = HTTParty.get('http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_week.geojson').to_hash["features"]

  max = 0

data.each_with_index do |element, index|
  current_karma = element["properties"]["mag"]

  if current_karma > max
    max = current_karma
  end
end

  send_event('karma', { current: current_karma, last: last_karma })
end

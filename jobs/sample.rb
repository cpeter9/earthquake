require 'httparty'
require 'sinatra'
require 'pry-debugger'

current_karma = 0
max_karma = 0
max_place = ''
last_karma = 0

SCHEDULER.every '30s' do
  data = HTTParty.get('http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson').to_hash["features"]

  data.each_with_index do |element, index|
    current_karma = element["properties"]["mag"]
    current_place = element["properties"]["place"]
  if current_karma > max_karma
      last_karma = max_karma
      max_karma = current_karma
      max_place = current_place
    end
  end

  send_event('karma', { current: max_karma, last: last_karma, place: max_place })
end

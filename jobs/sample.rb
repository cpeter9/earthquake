require 'httparty'
require 'sinatra'
require 'pry-debugger'

current_karma = 0
max_karma = 0
max_place = ''
last_karma = 0

SCHEDULER.every '30s' do
  last_karma = current_karma
  data = HTTParty.get('http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson').to_hash["features"]

    current_karma = data.first["properties"]["mag"]
    current_place = data.first["properties"]["place"]

  send_event('karma', { current: max_karma, last: last_karma, place: max_place })
end

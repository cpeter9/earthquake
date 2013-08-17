require 'httparty'
require 'sinatra'
require 'pry-debugger'

current_karma = 0
max_karma = 0

SCHEDULER.every '20s' do
  last_karma = max_karma
  data = HTTParty.get('http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_week.geojson').to_hash["features"]

  data.each_with_index do |element, index|
    current_karma = element["properties"]["mag"]
    if current_karma > last_karma
      max_karma = current_karma
    end
  end

  send_event('karma', { current: max_karma, last: last_karma })
end

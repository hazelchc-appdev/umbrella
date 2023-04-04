p "======================================== Will you need an umbrella today? ========================================"

p "Where are you located?"

user_location = gets.chomp

# user_location = "London"

p user_location

p "Checking the weather at #{user_location}...."

gmaps_token = ENV.fetch("GMAPS_KEY")

require "open-uri"

gmaps_api_endpoint = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_token}"

raw_response = URI.open(gmaps_api_endpoint).read

require "json"

parsed_response = JSON.parse(raw_response)

results_array = parsed_response.fetch("results")

first_result = results_array.at(0)

geo = first_result.fetch("geometry")

loc = geo.fetch("location")

latitude = loc.fetch("lat")

longitude = loc.fetch("lng")

p "Your coordinates are #{latitude}, #{longitude}."

### Fetch weather info
weather_token = ENV.fetch("PIRATE_WEATHER_KEY")

weather_api_endpoint = "https://api.pirateweather.net/forecast/#{weather_token}/#{latitude},#{longitude}"

weather_raw_response = URI.open(weather_api_endpoint).read

weather_parsed_response = JSON.parse(weather_raw_response)

currently = weather_parsed_response.fetch('currently')

current_temp = currently.fetch('temperature')

celsius = (current_temp - 32) * 5/9

p "It is currently #{celsius.round(1)}°C."

hourly = weather_parsed_response.fetch('hourly')

hourly_data = hourly.fetch("data")

num = 1 
precip_array = Array.new
while num <= 12
  precipProb = hourly_data[num].fetch("precipProbability")
  if precipProb > 0.1
    precip_array.push(precipProb)
    p "Possible precipitation starting in #{num} hours. The precipitation probability is #{precipProb*100}%"
    p  "You might want to carry an umbrella!"
    break
  end 
  num = num + 1
end

if precip_array == []
  p "You probably won't need an umbrella today."
end

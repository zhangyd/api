require 'rest-client'
require 'json'

puts "Welcome to Place Near Me! :)"


# Get the user's address and convert it into the latitude and longitude
puts "What is your address?"
address = gets.strip
puts "Looking around places near #{address}"
address = address.split.join("+")
response = RestClient.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=AIzaSyDQUBhF_Fz5gm4s4HFAr4nogZnKJkncRDc")
parsed_response = JSON.parse(response)
lat = parsed_response["results"][0]["geometry"]["location"]["lat"]
lng = parsed_response["results"][0]["geometry"]["location"]["lng"]

puts "What type of attraction are you looking for? (atm, restaurant, gym)"
type = gets.strip

puts "How far away would you like the farthest #{type} to be? Enter a number of meters"
radius= gets.strip

# Second API request: Nearby search by type
puts "Looking for #{type}s #{radius} meters away..."
attraction = RestClient.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyDQUBhF_Fz5gm4s4HFAr4nogZnKJkncRDc&location=#{lat},#{lng}&radius=#{radius}&sensor=false&types=#{type}")
parsed_attraction = JSON.parse(attraction)

#puts "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyDQUBhF_Fz5gm4s4HFAr4nogZnKJkncRDc&location=#{lat},#{lng}&radius=#{radius}&sensor=false&types=#{attraction}"

facilities = parsed_attraction["results"]

facilities.each_with_index do |facility, index|
    puts "#{index+1}. #{facility["name"]} | #{facility["vicinity"]}"
end

puts "Enter the number of the option for which you would like more details."
choice = gets.strip.to_i
choice -= 1 # gets choice back to IndexLand

choice_reference = facilities[choice]["reference"] 
facility_name = facilities[choice]["name"] # stores facility name
puts "Loading details for #{facility_name}..."

# Third API request: Retrieves detais for user's choice
details = RestClient.get("https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyDQUBhF_Fz5gm4s4HFAr4nogZnKJkncRDc&reference=#{choice_reference}&sensor=false")

parsed_details = JSON.parse(details)

parsed_details = parsed_details["result"]

puts "#{facility_name} details:"
puts "  Phone Number: #{parsed_details["international_phone_number"]}" 
puts "  Address: #{parsed_details["vicinity"]}"
puts "  Rating: #{parsed_details["rating"]}"




























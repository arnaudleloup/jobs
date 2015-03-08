require "json"
require "Date"

input_file = "backend/level1/data.json"
data = JSON.parse(IO.read(input_file))

input_rentals = data["rentals"]
cars = data["cars"]
output_rentals = []
  
input_rentals.each do |input_rental|
  car_id = input_rental["car_id"]
  car = nil
  cars.each do |c|
    car = c if c["id"] == car_id
  end 
  
  raise "the car with id=[#{car_id}] does not exist!" if car == nil
  
  distance = input_rental["distance"]

  start_date = Date.parse input_rental["start_date"]
  end_date = Date.parse input_rental["end_date"]
  days = (end_date - start_date).to_i + 1
  
  price = days * car["price_per_day"] + distance * car["price_per_km"]
    
  output_rental = {
    :id => input_rental["id"],
    :price => price
  }
  output_rentals.push(output_rental)
end  

output_file = "backend/level1/output.json"
output = {
  :rentals => output_rentals
}

File.open(output_file, "w") do |f|
  f.write(JSON.pretty_generate(output))
end
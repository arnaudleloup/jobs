require "json"
require "Date"

def read(file)
  data = JSON.parse(IO.read(file))
end

def write(file, output)
  File.open(file, "w") do |f|
    f.write(JSON.pretty_generate(output))
  end
end

def calc_time_price(days, price_per_day)
  price = 0
  if (days > 0)
    price = price_per_day
    days -= 1
  end
    
  if (days > 0)
    price += [3, days].min * price_per_day * 0.9  #decrease by 10%
    days -= 3
  end
  
  if (days > 0)
    price += [6, days].min * price_per_day * 0.7 #decrease by 30%
    days -= 6
  end
  
  if (days > 0)
    price += days * price_per_day * 0.5 #decrease by 50%
  end
  
  return price
end

def calc_commission(price, days)
  commission = price * 0.3
  insurance_fee = commission * 0.5
  assistance_fee = days * 100
  drivy_fee = [0, commission - insurance_fee - assistance_fee].max
  
  return {
    :insurance_fee => insurance_fee.to_i,
    :assistance_fee => assistance_fee,
    :drivy_fee => drivy_fee.to_i
  }
end

def calc_option(deductible_reduction, days)
  value = deductible_reduction ? days * 400 : 0
  return {
    :deductible_reduction => value
  }
end

def calc_output(cars, input_rental)
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
    
  price = calc_time_price(days, car["price_per_day"])
  price += distance * car["price_per_km"]
    
  deductible_reduction = calc_option(input_rental["deductible_reduction"], days)
  commission = calc_commission(price, days)
    
  return output_rental = {
    :id => input_rental["id"],
    :price => price.to_i,
    :options => deductible_reduction,
    :commission => commission
  }
end

data = read("backend/level4/data.json")

input_rentals = data["rentals"]
cars = data["cars"]
output_rentals = []
  
input_rentals.each do |input_rental|
  output_rentals.push(calc_output(cars, input_rental))
end

output = {
  :rentals => output_rentals
}

write("backend/level4/output.json", output)
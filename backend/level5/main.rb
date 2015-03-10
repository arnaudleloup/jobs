require "json"
require "Date"
require_relative "RentalsCalc"
require_relative "DriverAction"
require_relative "OwnerAction"
require_relative "InsuranceAction"
require_relative "AssistanceAction"
require_relative "DrivyAction"

def read(file)
  data = JSON.parse(IO.read(file))
end

def write(file, output)
  File.open(file, "w") do |f|
    f.write(JSON.pretty_generate(output))
  end
end

data = read("backend/level5/data.json")
rentals = RentalsCalc.new(data).rentals

output_rentals = []
rentals.each do |rental|
  rental_actions = [
    DriverAction.new.calc(rental),
    OwnerAction.new.calc(rental),
    InsuranceAction.new.calc(rental),
    AssistanceAction.new.calc(rental),
    DrivyAction.new.calc(rental),
  ]
  output_rentals.push({
   :id => rental[:id],
   :actions => rental_actions 
  }
  )
end

output = {
  :rentals => output_rentals
}

write("backend/level5/output.json", output)
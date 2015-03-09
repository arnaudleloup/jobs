require "json"
require_relative "ActorMoneyCalc"
require_relative "RentalsAfterModificationCalc"
require_relative "ActorDeltaAmountCalc"

def read(file)
  data = JSON.parse(IO.read(file))
end

def write(file, output)
  File.open(file, "w") do |f|
    f.write(JSON.pretty_generate(output))
  end
end

data = read("backend/level6/data.json")

# calculate the money by actor before the modifications
before = ActorMoneyCalc.new(data).output_rentals

# compute the data with the modification
RentalsAfterModificationCalc.new(data)

# calculate the money by actor after the modifications
after = ActorMoneyCalc.new(data).output_rentals

# calculate the delta amount
delta_amount = ActorDeltaAmountCalc.new(before, after, data["rental_modifications"]).delta_amount

# print it
output = {
  :rental_modifications => delta_amount
}

write("backend/level6/output2.json", output)
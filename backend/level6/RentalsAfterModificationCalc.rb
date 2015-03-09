require "json"
require "Date"

# Calculates the rentals data after applying the modifications.
# Note that if several modifications apply to the same rental (same rental_id)
# then all modifications are merged into the same result rental.
# Thus, we calculate the delta amount of the global modifications
# and not for each modification.
class RentalsAfterModificationCalc
  
  attr_reader :rentals
  
  def initialize(data)
    @data = data
    calc
  end

  private
  def calc
    rental_modifications = @data["rental_modifications"]
    rental_modifications.each do |rental_modification|
      rental_id = rental_modification["rental_id"]
      rental = nil
      @data["rentals"].each do |r|
        rental = r if r["id"] == rental_id
      end 
      
      raise "the rental with id=[#{rental_id}] does not exist!" if rental == nil
      
      rental["start_date"] = rental_modification["start_date"] unless rental_modification["start_date"] == nil
      rental["end_date"] = rental_modification["end_date"] unless rental_modification["end_date"] == nil
      rental["distance"] = rental_modification["distance"] unless rental_modification["distance"] == nil
    
    end
  end
end
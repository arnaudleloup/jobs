require "json"
require "Date"
require_relative "RentalsCalc"
require_relative "DriverAction"
require_relative "OwnerAction"
require_relative "InsuranceAction"
require_relative "AssistanceAction"
require_relative "DrivyAction"

class ActorMoneyCalc
  
  attr_reader :output_rentals

  def initialize(data)
    @data = data
    calc
  end
  
  private
  def calc
    #command pattern
    actions = {
      :driver => DriverAction.new,
      :owner => OwnerAction.new,
      :insurance => InsuranceAction.new,
      :assistance => AssistanceAction.new,
      :drivy => DrivyAction.new
    }
    
    rentals = RentalsCalc.new(@data).rentals
    
    @output_rentals = []
    rentals.each do |rental|
      rental_actions = [
        actions[:driver].calc(rental),
        actions[:owner].calc(rental),
        actions[:insurance].calc(rental),
        actions[:assistance].calc(rental),
        actions[:drivy].calc(rental),
      ]
      @output_rentals.push({
       :id => rental[:id],
       :actions => rental_actions 
      }
      )
    end
  end
end
require_relative "ActorAction"

class DriverAction < ActorAction

  public
  def calc(rental)
    return action("driver", "debit", price(rental) + deductible_reduction(rental))
  end
end
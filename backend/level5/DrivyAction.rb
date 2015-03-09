require_relative "ActorAction"

class DrivyAction < ActorAction

  public
  def calc(rental)
    return action("drivy", "credit", drivy_fee(rental) + deductible_reduction(rental))
  end
end
require_relative "ActorAction"

class OwnerAction < ActorAction

  public
  def calc(rental)
    return action("owner", "credit", price(rental) - insurance_fee(rental) - assistance_fee(rental) - drivy_fee(rental))
  end
end
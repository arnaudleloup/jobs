require_relative "ActorAction"

class InsuranceAction < ActorAction

  public
  def calc(rental)
    return action("insurance", "credit", insurance_fee(rental))
  end
end
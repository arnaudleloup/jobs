require_relative "ActorAction"

class AssistanceAction < ActorAction

  public
  def calc(rental)
    return action("assistance", "credit", assistance_fee(rental))
  end
end
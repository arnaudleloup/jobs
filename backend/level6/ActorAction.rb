class ActorAction

  private
  def commission(rental)
    return rental[:commission]
  end
  
  private
  def insurance_fee(rental)
    return commission(rental)[:insurance_fee]
  end
  
  private
  def assistance_fee(rental)
    return commission(rental)[:assistance_fee]
  end
  
  private
  def drivy_fee(rental)
    return commission(rental)[:drivy_fee]
  end
  
  private
  def deductible_reduction(rental)
    return rental[:options][:deductible_reduction]
  end
  
  private
  def price(rental)
    return rental[:price]
  end
  
  private 
  def action(who, type, amount)
    return {
      :who => who,
      :type => type,
      :amount => amount
    }
  end
end
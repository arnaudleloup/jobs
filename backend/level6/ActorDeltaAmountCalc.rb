class ActorDeltaAmountCalc
  
  attr_reader :delta_amount

  def initialize(before, after, modifications)
    @after = after
    
    # store the before rental by identifier for fast retrieval
    @before_by_id = {}
    before.each do |b|
      @before_by_id[b[:id]] = b
    end

    # store the modifications by given rental identifier for fast retrieval
    # the last modification applying to the rental is stored
    # see the note on the RentalsAfterModificationCalc class
    @modifications_by_rental_id = {}
    modifications.each do |modification|
      @modifications_by_rental_id[modification["rental_id"]] = modification
    end
      
    calc
  end
  
  # compute the amount delta for one rental
  private
  def rental_delta(before_actions, after_actions)
    deltas = []
      
    after_actions.each do |after_action|
      who = after_action[:who]
      after_amount = after_action[:amount]
      before_amount = nil
      before_actions.each do |before_action| # few actors, we can loop over them
        before_amount = before_action[:amount] if before_action[:who] == who
      end
      delta = after_amount - before_amount
      
      delta *= -1 if who == "driver" # driver credit logic is other actors reverse logic
      
      deltas.push({
        :who => who,
        :type => delta < 0 ? "debit" : "credit",
        :amount => delta.abs
      })
    end
    
    return deltas
  end

  # returns true if a computed delta is not null, returns false otherwise
  # a delta is not null if at least one actor amount delta is not 0
  private 
  def has_delta(delta)
    delta.each do |x|
      return true if x["amount"] != 0
    end
    
    return false
  end

  private
  def calc
    @delta_amount = []
    
    @after.each do |after_rental|
      rental_id = after_rental[:id]
      if @modifications_by_rental_id.has_key?(rental_id)
        before_rental = @before_by_id[rental_id]
  
        before_actions = before_rental[:actions]
        after_actions = after_rental[:actions]
        
        delta = rental_delta(before_actions, after_actions)
          
        # check if the rental has changed with the has_delta variable
        # no driver amount delta does not mean no change
        # because the data and distance modifications can balance out each other
        has_delta = has_delta(delta)
        modification = @modifications_by_rental_id[rental_id]
        modification_id = modification["id"]
        @delta_amount.push({
          :id => modification_id,
          :rental_id => rental_id,
          :actions => delta
        }) if has_delta
      end
    end
  end

end
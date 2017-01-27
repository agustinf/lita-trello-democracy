class SelectVotingCards < PowerTypes::Command.new(:user, :cards)
  def perform
    voting_cards = @cards.sort_by { |c| c.votes.count + c.pending_votes_count.to_i }.first(3)
    voting_cards.each { |v_card| v_card.pending_votes_count = v_card.pending_votes_count.to_i + 1 }
    voting_cards.shuffle
  end
end
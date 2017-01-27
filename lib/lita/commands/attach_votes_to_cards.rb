class AttachVotesToCards < PowerTypes::Command.new(:cards, :redis)
  def perform
    votes_by_card = get_votes.group_by(&:card_id)
    @cards.each do |card|
      card.votes = votes_by_card[card.id] || []
    end
  end

  private

  def get_votes
    @redis.smembers("votes").map { |votes_json| Vote.from_dump(votes_json) }
  end
end
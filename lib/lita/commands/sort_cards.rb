class SortCards < PowerTypes::Command.new(:cards, :votes)
  def perform
    scored_cards = []
    @cards.each do |c|
      card_votes = @votes.select { |v| v.card_id == c.id }
      score = card_votes.map { |v| v.score * Math.exp((1/86400)*(v.voted_at - Time.now)) }.inject(:+) / card_votes.size
      scored_cards << {card: c, score:score}
    end
    scored_cards.sort { |x,y| x["score"] <=> y["score"] }.map(&:card)
  end
end

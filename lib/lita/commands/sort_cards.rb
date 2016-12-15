class SortCards < PowerTypes::Command.new(:cards, :votes)
  def perform
    SECONDS_IN_MONTH = 86400*30
    scored_cards = []
    @cards.each do |c|
      card_votes = @votes.select { |v| v.card_id == c.id }
      score = card_votes.map { |v| v.score * Math.exp((v.voted_at - Time.now)/(SECONDS_IN_MONTH*10)) }.inject(:+) / card_votes.size
      scored_cards << {card: c, score:score}
    end
    scored_cards.sort { |x,y| x["score"] <=> y["score"] }.map(&:card)
  end
end

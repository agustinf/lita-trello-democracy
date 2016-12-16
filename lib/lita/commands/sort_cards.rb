class SortCards < PowerTypes::Command.new(:cards, :votes)
  def perform
    scored_cards = []
    @cards.each do |c|
      card_votes = @votes.select { |v| v.card_id == c.id }
      if card_votes.empty?
        score = 0
      else
        score = card_votes.map { |v| v.score * Math.exp((1/86400*30*10)*(v.voted_at - Time.now)) }
                          .inject(:+) / Math.sqrt(card_votes.size)
      end
      scored_cards << {card: c, score:score}
    end
    scored_cards.sort { |x,y| y[:score] <=> x[:score] }.map { |sorted_card| sorted_card[:card] }
  end
end

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
      c.score = score
      c.votes = card_votes.count
      scored_cards << c
    end
    scored_cards.sort_by(&:score).reverse
  end
end

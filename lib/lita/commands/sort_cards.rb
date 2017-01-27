class SortCards < PowerTypes::Command.new(:cards, :votes)
  def perform
    scored_cards = []
    @cards.each do |c|
      card_votes = @votes.select { |v| v.card_id == c.id }
      c.score = card_votes.empty? ? 0 : card_votes.map(&:score).inject(:+)
      c.votes = card_votes.count
      scored_cards << c
    end
    scored_cards.sort_by(&:score).reverse
  end
end

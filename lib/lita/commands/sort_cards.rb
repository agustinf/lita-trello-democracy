class SortCards < PowerTypes::Command.new(:cards)
  def perform
    scored_cards = []
    @cards.each do |c|
      c.score = card.votes.empty? ? 0 : card.votes.map(&:score).inject(:+)
      scored_cards << c
    end
    scored_cards.sort_by(&:score).reverse
  end
end

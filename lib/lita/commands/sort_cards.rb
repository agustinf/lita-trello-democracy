class SortCards < PowerTypes::Command.new(:cards)
  def perform
    @cards.sort_by(&:score).reverse
  end
end

class SyncCards < PowerTypes::Command.new(:redis, :cards)
  def perform
    @cards.each { |c| @redis.add("new_cards", c.dump) }
    @redis.sinterstore("cards", "new_cards")
  end
end

class SyncCards < PowerTypes::Command.new(:redis, :cards)
  def perform
    @redis.del("cards")
    @cards.each { |c| @redis.sadd("cards", c.dump) }
  end
end

require 'json'
class VotingService < PowerTypes::Service.new(:redis)
  def save_vote(vote)
    @redis.sadd("votes", vote.dump)
  end

  def reset_pending_votes(user)
    pending = user_pending_votes(user).map(&:to_json)
    @redis.srem("pending-votes", pending) unless pending.empty?
  end

  def store_pending_vote(user, card_ids)
    new_pending = { user: user, card_ids: card_ids }.to_json
    @redis.sadd("pending-votes", new_pending)
  end

  def get_pending_vote_card_ids(user)
    user_pending_votes(user).first["card_ids"]
  end

  private

  def user_pending_votes(user)
    @redis.smembers("pending-votes").map { |json_pv| JSON.parse(json_pv) }.select do |hash_pv|
      hash_pv["user"] == user
    end
  end
end

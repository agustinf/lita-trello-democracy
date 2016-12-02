require 'json'
require 'time'
class Vote
  attr_accessor :user, :card_id, :score, :voted_at

  def initialize(args)
    @user = args[:user]
    @card_id = args[:card_id]
    @score = args[:score]
    @voted_at = Time.parse(args[:voted_at])
  end

  def dump
    {
      user: user,
      card_id:  card_id,
      score:  score,
      voted_at:  voted_at
    }.to_json
  end

  def self.from_dump(_dump)
    args_hash = JSON.parse(_dump, symbolize_names: true)
    Vote.new(args_hash)
  end
end

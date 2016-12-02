require 'json'
require 'time'
class Card
  attr_accessor :id, :name, :owner, :created_at

  def initialize(args)
    @id = args[:id]
    @name = args[:name]
    @owner = args[:owner]
    @created_at = Time.parse(args[:created_at].to_s)
  end

  def ==(other_card)
    id == other_card.id
  end

  def dump
    {
      id: id,
      name: name,
      owner: owner,
      created_at: created_at
    }.to_json
  end

  def self.from_dump(_dump)
    args_hash = JSON.parse(_dump, symbolize_names: true)
    Card.new(args_hash)
  end
end

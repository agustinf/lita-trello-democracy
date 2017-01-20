require 'json'
require 'time'
class Card
  attr_accessor :id, :name, :short_url, :desc, :score, :votes

  def initialize(args)
    @id = args[:id]
    @name = args[:name]
    @short_url = args[:short_url]
    @desc = args[:desc]
  end

  def ==(other_card)
    id == other_card.id
  end

  def dump
    {
      id: id,
      name: name,
      short_url: short_url,
      desc: desc
    }.to_json
  end

  def self.from_dump(_dump)
    args_hash = JSON.parse(_dump, symbolize_names: true)
    Card.new(args_hash)
  end
end

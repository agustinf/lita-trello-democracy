module Lita
  module Commands
    module Trello
      class SortCards < Base
        def initialize(options)
          options[:trello_objects] = true
          @get_cards_cmd = GetCards.for(options)
          @cards = options.delete(:cards)
          super
        end

        def perform
          trello_cards = @get_cards_cmd
          trello_cards.each do |card|
            pos = pos_map[card.id] || trello_cards.count
            score_regex =  Regexp.new '^\[(-?\d+)?p\/(\d+)?v\]\s'
            clean_card_name = card.name.gsub(score_regex, "")
            card.name = "[#{get_score(card.id)}p/#{get_votes(card.id)}v] #{clean_card_name}"
            card.pos = pos
            card.save
          end
        end

        private

        def pos_map
          map = {}
          @cards.each_with_index { |card, index| map[card.id] = index + 1 }
          map
        end

        def get_score(id)
          @cards.select {|card| card.id == id }.first.try(:score).try(:round)
        end

        def get_votes(id)
          @cards.select {|card| card.id == id }.first.try(:votes)
        end
      end
    end
  end
end

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
            card.name = get_card(card.id).name_with_stats
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

        def get_card(id)
          @cards.find {|card| card.id == id }
        end
      end
    end
  end
end

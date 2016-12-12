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
      end
    end
  end
end

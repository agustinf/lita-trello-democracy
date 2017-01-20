module Lita
  module Commands
    module Trello
      class GetCards < Base
        def initialize(options)
          @trello_objects = !!options.delete(:trello_objects)
          super
        end

        def perform
          inbox_cards
        end

        private

        def platanus_board
          ::Trello::Board.all.each { |board| return board if board.name == ENV.fetch("TRELLO_BOARD_NAME") }
          raise "#{ENV.fetch("TRELLO_BOARD_NAME")} board not found"
        end

        def inbox_list
          platanus_board.lists.each { |list| return list if Regexp.new(ENV.fetch("TRELLO_LIST_NAME")) =~ list.name }
          raise "#{ENV.fetch("TRELLO_LIST_NAME")} list not found"
        end

        def inbox_cards
          cards = inbox_list.cards
          return cards if @trello_objects
          inbox_list.cards.map do |card|
            ::Card.new(
              id: card.id,
              name: card.name,
              short_url: card.short_url,
              desc: card.desc
            )
          end
        end
      end
    end
  end
end

module Lita
  module Commands
    module Trello
      class GetCards < Base
        def perform
          inbox_cards
        end

        private

        def platanus_board
          ::Trello::Board.all.each { |board| return board if board.name == "Platanus" }
          raise "Platanus board not found"
        end

        def inbox_list
          platanus_board.lists.each { |list| return list if /INBOX/ =~ list.name }
          raise "INBOX list not found"
        end

        def inbox_cards
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

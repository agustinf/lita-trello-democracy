module Lita
  module Commands
    module Trello
      class GetRandomCards < Base
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
          inbox_list.cards.sample(3)
        end
      end
    end
  end
end

class GenerateRankingMessage < PowerTypes::Command.new(:sorted_cards, :unsorted_cards, :card_ids)
  def perform
    response = []
    @sorted_cards.each_with_index do |card, index|
      if is_voted_card?(card)
        unsorted_index = @unsorted_cards.index { |u| u.id == card.id }
        if (unsorted_index > index)
          icon = ":arrow_up:"
        elsif (unsorted_index < index)
          icon = ":arrow_down:"
        else
          icon = ":heavy_minus_sign:"
        end
        response.push("#{index + 1}º #{icon} #{card.name_with_stats}")
      end
    end
    response
  end

  private

  def is_voted_card?(card)
    @card_ids.find { |id| id == card.id }
  end
end

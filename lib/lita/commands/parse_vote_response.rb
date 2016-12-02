class ParseVoteResponse < PowerTypes::Command.new(:user, :card_ids, :response)
  def perform
    ordered_indexes = @response.delete(" ").split(",").map(&:to_i)
    ordered_indexes.to_enum.with_index(1).map do |card_index, position|
      Vote.new(
        user: @user,
        card_id: @card_ids[card_index - 1],
        score: score_table[position],
        voted_at: Time.now
      )
    end
  end

  private

  def score_table
    {
      1 => 1,
      2 => 0,
      3 => -1
    }
  end
end

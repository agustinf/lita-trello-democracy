require "spec_helper"

RSpec.describe Lita::Commands::Trello::SortCards do
  let(:cards) do
    [
      ::Card.new(id: "XXX3"),
      ::Card.new(id: "XXX1"),
      ::Card.new(id: "XXX2")
    ]
  end

  let(:trello_cards) do
    [
      double(id: "XXX1"),
      double(id: "XXX2"),
      double(id: "XXX3"),
      double(id: "XXX4"),
      double(id: "XXX5")
    ]
  end

  let(:options) do
    {
      config: double(developer_public_key: 'XXX', member_token: 'YYY'),
      cards: cards
    }
  end

  let(:exec_cmd) { described_class.for(options) }

  before do
    allow(Lita::Commands::Trello::GetCards).to receive(:for).and_return(trello_cards)
  end

  def expect_to_save_pos(idx, new_pos)
    expect(trello_cards[idx]).to receive("pos=").with(new_pos)
    expect(trello_cards[idx]).to receive(:save)
  end

  describe "#perform" do
    it "updates cards' positions" do
      expect_to_save_pos(0, 2)
      expect_to_save_pos(1, 3)
      expect_to_save_pos(2, 1)
      expect_to_save_pos(3, 5)
      expect_to_save_pos(4, 5)
      exec_cmd
    end
  end
end

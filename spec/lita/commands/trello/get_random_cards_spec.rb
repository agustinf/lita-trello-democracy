require "spec_helper"

RSpec.describe Lita::Commands::Trello::GetRandomCards do
  let(:config) do
    double(developer_public_key: 'XXX', member_token: 'YYY')
  end

  let(:exec_cmd) { described_class.for(config) }

  let(:cards) do
    [
      double(id: "XXX1", name: "Card 1", desc: "Description 1", pos: 1),
      double(id: "XXX2", name: "Card 2", desc: "Description 2", pos: 2),
      double(id: "XXX3", name: "Card 3", desc: "Description 3", pos: 3),
      double(id: "XXX4", name: "Card 4", desc: "Description 4", pos: 4),
      double(id: "XXX5", name: "Card 5", desc: "Description 5", pos: 5)
    ]
  end

  let(:lists) do
    [
      double(name: "INBOX", id: "XXX", cards: cards),
      double(name: "Presentación 16/11", id: "YYY")
    ]
  end

  let(:boards) do
    [
      double(name: "Board 1", id: "XXX"),
      double(name: "Board 2", id: "YYY"),
      double(name: "Platanus", id: "ZZZ", lists: lists)
    ]
  end

  def mock_boards
    allow(::Trello::Board).to receive(:all).and_return(boards)
  end

  describe "#perform" do
    context "without platanus board" do
      before do
        boards.pop
        mock_boards
      end

      it "raises error" do
        expect { exec_cmd }.to raise_error("Platanus board not found")
      end
    end

    context "without INBOX list" do
      before do
        boards[boards.count - 1] = double(name: "Platanus", id: "ZZZ", lists: [])
        mock_boards
      end

      it "raises error" do
        expect { exec_cmd }.to raise_error("INBOX list not found")
      end
    end

    context "with valid data" do
      before { mock_boards }

      it "returns 3 random cards" do
        expect(exec_cmd.count).to eq(3)
      end

      it "returns random cards" do
        expect(cards).to include(*exec_cmd)
      end
    end
  end
end

require "spec_helper"

RSpec.describe Lita::Commands::Trello::GetCards do
  let(:config) do
    double(developer_public_key: 'XXX', member_token: 'YYY')
  end

  let(:exec_cmd) { described_class.for(config) }

  let(:cards) do
    [
      double(id: "XXX1", name: "Card 1", desc: "Description 1", short_url: "https://trello.com/a"),
      double(id: "XXX2", name: "Card 2", desc: "Description 2", short_url: "https://trello.com/b"),
      double(id: "XXX3", name: "Card 3", desc: "Description 3", short_url: "https://trello.com/c"),
      double(id: "XXX4", name: "Card 4", desc: "Description 4", short_url: "https://trello.com/d"),
      double(id: "XXX5", name: "Card 5", desc: "Description 5", short_url: "https://trello.com/e")
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

      it { expect { exec_cmd }.to raise_error("Platanus board not found") }
    end

    context "without INBOX list" do
      before do
        boards[boards.count - 1] = double(name: "Platanus", id: "ZZZ", lists: [])
        mock_boards
      end

      it { expect { exec_cmd }.to raise_error("INBOX list not found") }
    end

    context "with valid data" do
      before { mock_boards }

      it { expect(exec_cmd.count).to eq(5) }
      it { expect(cards).to include(*exec_cmd) }
    end
  end
end

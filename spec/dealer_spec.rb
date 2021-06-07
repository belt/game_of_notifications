require "#{__dir__}/shared/player"

RSpec.describe Dealer do
  subject(:dealer) do
    described_class.new
  end

  it_behaves_like "a player"

  it "insists player names are non-blank" do
    expect(described_class.new.name).to eq("I am root")
  end

  it "has a deck" do
    expect(dealer.deck).to be_a_kind_of(Deck)
  end

  context "when dealer cheats" do
    before { described_class.config.dealer_always_wins = true }

    it "includes the dealer in the winners list" do
    end
  end
end

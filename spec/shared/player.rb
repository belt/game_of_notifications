RSpec.shared_examples_for "a player" do
  it "has a name" do
    expect(player.name).to_not be_nil
  end

  context "when initializing round setup" do
    it "requests 2 cards from the dealer" do
    end
  end

  context "when ending a round" do
    it "returns cards to the dealers-deck" do
    end
  end
end

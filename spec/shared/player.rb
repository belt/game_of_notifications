RSpec.shared_examples_for "a player" do
  it "insists player names are non-blank", :aggregate_failures do
    expect(described_class.new(name: "Paul").name).to eq "Paul"

    expect { described_class.new nil }.to raise_error(ArgumentError)
    expect { described_class.new "" }.to raise_error(ArgumentError)
    expect { described_class.new " " }.to raise_error(ArgumentError)
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

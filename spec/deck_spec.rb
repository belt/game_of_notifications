RSpec.describe Deck do
  subject(:deck) do
    described_class.new
  end

  shared_examples_for "counting cards" do
    it "reports number of cards remaining in the deck" do
    end

    it "drawing a card reduces deck count", :aggregate_failures do
    end
  end

  shared_examples_for "dealing a card" do
    it "draws a card from the deck" do
    end

    it "draws a different random card from the deck with each call" do
    end
  end

  context "when initializing" do
    context "when shuffling" do
      it_behaves_like "dealing a card"
      it_behaves_like "counting cards"

      it "shuffles the order of cards" do
      end
    end

    context "when not shuffling" do
      it_behaves_like "dealing a card"
      it_behaves_like "counting cards"
    end
  end
end

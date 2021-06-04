RSpec.describe Deck do
  subject(:deck) do
    described_class.new
  end

  shared_examples_for "counting cards" do
    it "reports number of cards remaining in the deck" do
      expect(deck.count).to eq(52)
    end

    it "drawing a card reduces deck count", :aggregate_failures do
      expect { deck.draw }.to change(deck, :count).by(-1)
      expect do
        deck.draw
        deck.draw
      end.to change(deck, :count).by(-2)
    end
  end

  shared_examples_for "dealing a card" do
    it "draws a card from the deck" do
      expect(deck.draw).to be_a_kind_of(Card)
    end

    it "draws a different random card from the deck with each call" do
      first_draw = deck.draw
      second_draw = deck.draw
      first_suit = first_draw.suit
      second_suit = second_draw.suit
      expect([first_suit, first_draw.value]).not_to eq([second_suit, second_draw.value])
    end
  end

  context "when initializing" do
    context "when shuffling" do
      it_behaves_like "dealing a card"
      it_behaves_like "counting cards"

      it "shuffles the order of cards" do
        expect { deck.shuffle }.to change(deck, :cards)
      end
    end

    context "when not shuffling" do
      it_behaves_like "dealing a card"
      it_behaves_like "counting cards"
    end
  end
end

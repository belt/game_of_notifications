RSpec.describe Game do
  subject(:game) do
    described_class.new
  end

  let(:dealer) { Dealer.new }

  let(:artisan) { Player.new name: "Considers technologies akin to playing with Legos (TM)" }
  let(:engineer) { Player.new name: "More than one language, best-practices" }
  let(:developer) { Player.new name: "One language, less than 5 yrs XP" }
  let(:syntax_jockey) { Player.new name: "Bootcamp graduate" }
  let(:not_a_coder) { Player.new name: "Bossen" }
  let(:players) do
    [artisan, engineer, developer, syntax_jockey, not_a_coder].shuffle
  end

  let(:player) { players.shuffle }

  context "when starting a game" do
    context "when a dealer and 4 players want to play a game" do
      it "waits for the 5th player" do
      end
    end

    context "when 5 players and no dealer want to play a game" do
      it "waits for the dealer" do
      end
    end

    context "when a dealer and 5 players want to play a game" do
      it "has a dealer and a set of players", :aggregate_failures do
        expect(game.players).to be_a_kind_of(Set)
        expect(game.dealer).to be_a_kind_of(Dealer)
      end

      it "has a dealer and 5 players" do
      end
    end

    context "when a dealer and 6 players want to play a game" do
      # NOTE: limits games to 5 players
      it "has a dealer and 5 players" do
      end

      # NOTE: tracks games played
      it "makes the 6th player wait until the next game" do
      end
    end
  end

  context "when playing a game" do
    context "when handing out cards" do
      it "gives 2 cards to each player and 2 to the dealer", :aggregate_failures do
      end
    end
  end

  shared_examples_for "end of typical round" do
    it "the correct winners are announced" do
    end

    it "all cards are returned to the dealer", :aggregate_failures do
    end
  end

  context "when ending a game" do
    context "when a player wins" do
      it_behaves_like "end of typical round"

      context "when the house always wins" do
        # NOTE: e.g. hand folded, fires, C-x + M-m + M-butterfly, sunspots...
        it "the dealer is declared winner anyway" do
        end

        it "all cards are returned to the dealer", :aggregate_failures do
        end
      end
    end

    context "when the dealer wins" do
      it_behaves_like "end of typical round"
    end
  end
end

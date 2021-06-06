require "active_support/notifications"

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

  let(:player) { players.sample }

  context "when starting a game" do
    context "when a player sits at a table" do
      before do
        game # ensure game is instantiated else listeners aren't bound

        allow(ActiveSupport::Notifications).to receive(:publish).and_call_original
      end

      it "increases the player-count by 1" do
        expect { player.enter_game }.to change(game.players, :count).by(1)
      end

      it "announces the player enters the game and provides tokens", :aggregate_failures do
        # rubocop:disable RSpec/MessageSpies
        expect(ActiveSupport::Notifications).to receive(:publish).with(
          "player.enters_game",
          player_name: player.name
        ).ordered
        expect(ActiveSupport::Notifications).to receive(:publish).with(
          "game.provides_game_tokens",
          player_name: player.name, game_token: a_kind_of(String),
          player_token: a_kind_of(String)
        ).ordered
        # rubocop:enable RSpec/MessageSpies

        player.enter_game
      end

      context "when a player by that name is already sitting" do
        it "the clone wars, begun have they" do
          player.enter_game
          expect { player.enter_game }.not_to change(game.players, :count)
        end
      end
    end

    context "when a dealer and 4 players want to play a game" do
      subject(:seated_players) { players[0..3] }

      let(:game) { described_class.new }

      before { game }

      it "increases the player-count by 4" do
        expect do
          seated_players.each(&:enter_game)
        end.to change(game.players, :count).by(4)
      end

      it "lets the 5th player join the game" do
        seated_players.each(&:enter_game)
        new_player = (players - seated_players).shift

        expect { new_player.enter_game }.to change(game.players, :count).by(1)
      end

      context "when a 5th player enters the game" do
        before do
          allow(ActiveSupport::Notifications).to receive(:publish).and_call_original

          seated_players.each(&:enter_game)
        end

        let(:new_player) { (players - seated_players).shift }

        it "increases the player count by 1" do
          expect { new_player.enter_game }.to change(game.players, :count).by(1)
        end

        it "announces the game starts when the 5th enters", :aggregate_failures do
          # rubocop:disable RSpec/MessageSpies
          expect(ActiveSupport::Notifications).to receive(:publish).with(
            "player.enters_game",
            player_name: new_player.name
          ).ordered
          expect(ActiveSupport::Notifications).to receive(:publish).with(
            "game.provides_game_tokens",
            player_name: new_player.name, game_token: a_kind_of(String),
            player_token: a_kind_of(String)
          ).ordered
          # rubocop:enable RSpec/MessageSpies

          new_player.enter_game
        end
      end
    end

    context "when 5 players and no dealer want to play a game" do
      it "waits for the dealer" do
        skip "in the interest of time"
      end
    end

    context "when a dealer and 5 players want to play a game" do
      it "has a dealer and a set of players", :aggregate_failures do
        expect(game.players).to be_a_kind_of(Set)
        expect(game.dealer).to be_a_kind_of(Dealer)
      end

      context "when game has a dealer and 5 players" do
        subject(:seated_players) { players[0..3] }

        before do
          game
          seated_players.each(&:enter_game)
        end

        let(:new_player) { Dealer.new name: "I am root" }
        let(:player_two) { Player.new(name: "StackOverflow Test") }

        it "does not let a 6th player join" do
          expect do
            player_two.enter_game
            new_player.enter_game # tricksters need not apply
          end.to change(game.players, :count).by(1)
        end
      end
    end

    context "when a dealer and 6 players want to play a game" do
      # NOTE: limits games to 5 players
      it "has a dealer and 5 players" do
        skip "in the interest of time"
      end

      # NOTE: tracks games played
      it "makes the 6th player wait until the next game" do
        skip "in the interest of time"
      end
    end
  end

  context "when playing a game" do
    subject(:seated_players) { players[0..4] }

    let(:game) { described_class.new }

    before do
      game # ensure game is instantiated else listeners aren't bound
    end

    context "when handing out cards to all seated players" do
      before do
        allow(ActiveSupport::Notifications).to receive(:publish).and_call_original

        seated_players.each(&:enter_game)
      end

      it "gives 2 cards to each player and 2 to the dealer", :aggregate_failures do
        expect(game.players.count).to eq(5)
        expect(game.players).to match_array((0..4).map { |_| a_kind_of(Player) })
        expect(game.dealer).to be_a_kind_of(Player)
        expect(game).to be_completed

        hand_schema = players.each_with_object({}) do |risk_taker, acc|
          acc[risk_taker.name] = a_kind_of(Set)
          acc
        end
        hand_schema[dealer.name] = a_kind_of(Set)

        expect(game.hands.keys).to match_array(hand_schema.keys)

        expect(game.hands).to include(hand_schema)
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

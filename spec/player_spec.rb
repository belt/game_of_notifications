require "#{__dir__}/shared/player"

RSpec.describe Player do
  subject(:player) do
    # TODO: Faker::Names.full_name
    described_class.new name: "Paul"
  end

  it_behaves_like "a player"

  it "insists player names are non-blank" do
    expect { described_class.new }.to raise_error(ArgumentError)
  end

  context "when starting a game" do
    context "when player sits at a table" do
      before do
        game # ensure player is instantiated else listeners aren't bound

        allow(ActiveSupport::Notifications).to receive(:publish).and_call_original
      end

      let(:game) { Game.new }

      it "player notifies game an I am here message" do
        # rubocop:disable RSpec/MessageSpies
        expect(ActiveSupport::Notifications).to receive(:publish).with(
          "player.enters_game",
          { player_name: player.name }
        ).ordered
        expect(ActiveSupport::Notifications).to receive(:publish).with(
          "game.provides_game_tokens",
          {
            game_token: a_kind_of(String), player_name: player.name,
            player_token: a_kind_of(String)
          }
        ).ordered
        # rubocop:enable RSpec/MessageSpies

        player.enter_game
      end
    end

    context "when player fills a table" do
      let(:artisan) do
        described_class.new name: "Considers technologies akin to playing with Legos (TM)"
      end
      let(:game) { Game.new }
      let(:engineer) { described_class.new name: "More than one language, best-practices" }
      let(:developer) { described_class.new name: "One language, less than 5 yrs XP" }
      let(:syntax_jockey) { described_class.new name: "Bootcamp graduate" }
      let(:not_a_coder) { described_class.new name: "Bossen" }
      let(:all_players) do
        [artisan, engineer, developer, syntax_jockey, not_a_coder].shuffle
      end

      before do
        game # ensure player is instantiated else listeners aren't bound

        allow(ActiveSupport::Notifications).to receive(:publish).and_call_original
      end

      it "player notifies game an I am here message" do
        # rubocop:disable RSpec/MessageSpies
        expect(ActiveSupport::Notifications).to receive(:publish).with(
          "player.enters_game",
          { player_name: player.name }
        ).ordered
        expect(ActiveSupport::Notifications).to receive(:publish).with(
          "game.provides_game_tokens",
          {
            game_token: a_kind_of(String), player_name: player.name,
            player_token: a_kind_of(String)
          }
        ).ordered

        player.enter_game
      end
    end
  end
end

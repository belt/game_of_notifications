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
        allow(ActiveSupport::Notifications).to receive(:publish).with(
          "player.enters_game",
          player_name: player.name
        ).and_call_original
      end

      it "player notifies game an I am here message", :aggregate_failures do
        expect(player.enter_game).to be_a_kind_of(Game)
        expect(ActiveSupport::Notifications).to have_received(:publish).with(
          "player.enters_game",
          player_name: player.name
        )
      end
    end
  end
end

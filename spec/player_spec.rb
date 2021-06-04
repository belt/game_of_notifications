require "#{__dir__}/shared/player"

RSpec.describe Player do
  subject(:player) do
    described_class.new
  end

  it_behaves_like "a player"

  it "insists player names are non-blank" do
    expect { described_class.new }.to raise_error(ArgumentError)
  end
end

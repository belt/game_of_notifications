require "#{__dir__}/shared/player"

RSpec.describe Dealer do
  subject(:dealer) do
    described_class.new
  end

  it_behaves_like "a player"

  it "insists player names are non-blank", :aggregate_failures do
    expect { described_class.new }.not_to raise_error(ArgumentError)
    expect(described_class.new.name).to eq("I am root")
  end
end

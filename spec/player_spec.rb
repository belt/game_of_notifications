require "#{__dir__}/shared/player"

RSpec.describe Player do
  subject(:player) do
    described_class.new
  end

  it "insists players have non-blank names", :aggregate_failures do
    expect( described_class.new(name: "Paul").name ).to eq "Paul"

    expect{ described_class.new }.to raise_error(ArgumentError)
    expect{ described_class.new nil}.to raise_error(ArgumentError)
    expect{ described_class.new "" }.to raise_error(ArgumentError)
    expect{ described_class.new " "}.to raise_error(ArgumentError)
  end
end

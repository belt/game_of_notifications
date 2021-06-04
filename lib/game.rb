# We got game
class Game
  attr_accessor :dealer
  attr_reader :players

  def initialize
    @players = Set.new
    @dealer = Dealer.new
  end
end

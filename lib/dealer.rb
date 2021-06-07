require "active_support/configurable"
require "active_support/core_ext/module/delegation"

# a slight-of-hand specialist
class Dealer < Player
  include ActiveSupport::Configurable
  config_accessor :dealer_always_wins

  config.dealer_always_wins = false

  def initialize(**kwargs)
    @name = kwargs.fetch(:name, "I am root")
    @token = SecureRandom.uuid
    super name: @name
  end

  def deck
    @deck ||= Deck.new
  end

  def open_new_pack
    @deck = Deck.new
  end

  delegate :draw, to: :deck
end

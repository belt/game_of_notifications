require "active_support/configurable"
require "active_support/core_ext/module/delegation"
require "deck-of-cards"

class Deck
  include ActiveSupport::Configurable
  config_accessor :shuffle_upon_initialize

  config.shuffle_upon_initialize = true

  def initialize
    @deck = DeckOfCards.new
    @deck.shuffle if config.shuffle_upon_initialize
    @deck
  end
  alias_method :open_new_deck, :initialize

  def deck
    @deck ||= open_new_pack
  end

  delegate :count, to: :cards
  delegate :cards, :draw, :shuffle, to: :deck
end

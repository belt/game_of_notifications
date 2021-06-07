require "active_support/configurable"

# translate card into numerical value depending on configuration
module CardTranslator
  include ActiveSupport::Configurable
  config_accessor :base_of_deck, :aces_high

  config.aces_high = false
  config.base_of_deck = 10

  ACE_VALUE = { high: 11, low: 1 }.freeze
  BASE10_DECK = { "King" => 10, "Queen" => 10, "Jack" => 10 }.freeze
  BASE13_DECK = { "King" => 13, "Queen" => 12, "Jack" => 11 }.freeze

  module_function

  def translate_card(card:)
    case rank = card.rank
    when "Ace"
      raise "not implemented" if config[:aces_high] == true

      ACE_VALUE[:low]
    when "King", "Queen", "Jack"
      config[:base_of_deck] == 10 ? BASE10_DECK[rank] : BASE13_DECK[rank]
    else
      card.value
    end
  end
end

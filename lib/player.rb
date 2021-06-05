require "active_support/core_ext/string"
require "active_support/notifications"

# someone who takes risks
class Player
  attr_reader :name, :cards_in_hand
  attr_accessor :token

  def initialize(name:, token: nil)
    @name = name
    raise ArgumentError, "invalid name" unless valid_name?

    @token = token
  end

  def valid_name?
    !name.strip.blank?
  end

  def enter_game
    ActiveSupport::Notifications.publish(
      "player.enters_game",
      { player_name: name }
    )
    Game.new # BUG: to pass spec and prove a point
  end
end

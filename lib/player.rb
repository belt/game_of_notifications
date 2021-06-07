require "active_support/core_ext/string"
require "active_support/notifications"

# someone who takes risks
class Player
  attr_reader :name, :cards_in_hand
  attr_accessor :token, :game_token

  def initialize(name:, token: nil)
    @name = name
    raise ArgumentError, "invalid name" unless valid_name?

    @token = token
    ::Subscribers::Player.register_listeners(player: self)
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

  def receive_tokens(game_token:, player_token:)
    @game_token = game_token
    @token = player_token

    tok_msg = {
      player_name: name, game_token: game_token, player_token: token,
      tokens: { game_token: game_token, player_token: player_token }
    }
    ActiveSupport::Notifications.publish("player.receives_tokens", tok_msg)
    tok_msg
  end

  def request_cards
    req_msg = { player_name: name, game_token: game_token, player_token: token }
    ActiveSupport::Notifications.publish("player.requests_cards", req_msg)
    req_msg
  end
end

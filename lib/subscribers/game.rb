module Subscribers
  # listens for game activity
  module Game
    module_function

    def register_listeners(game:)
      ActiveSupport::Notifications.subscribe("player.enters_game") do |_, msg|
        player_name = msg[:player_name]

        # don't be rude: acknowledge the player even if no tokens are available
        unless game.player_already_sitting?(player_name: player_name)
          player = ::Player.new(name: player_name)
          game.acknowledge_player(player: player)
        end

        game
      end

      ActiveSupport::Notifications.subscribe("player.receives_tokens") do |_, msg|
        player = game.player_already_sitting?(player_name: player_name(msg: msg))

        # if the tables full, start a game
        if game.game_token == msg_game_token(msg: msg) && player &&
           !game.started? &&
           game.players.count >= 5 && game.dealer
          game.trigger(status: :started)
        end
      end
    end
  end
end

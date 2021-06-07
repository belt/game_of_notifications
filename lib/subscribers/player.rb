module Subscribers
  # listens for player activity
  module Player
    module_function

    def register_listeners(player:)
      ActiveSupport::Notifications.subscribe("game.provides_game_tokens") do |_, msg|
        player_name = msg[:player_name]
        player_token = msg[:player_token]

        # only listen for messages meant for us
        msg = if player.name == player_name &&
                 player.token == player_token
          player.receive_tokens(**msg.slice(:game_token, :player_token))

          { game_token: msg[:game_token], player_name: player_name }
        end

        msg
      end

      ActiveSupport::Notifications.subscribe("player.receives_cards") do |_, msg|
        player_name = msg[:player_name]
        player_token = msg[:player_token]

        # only listen for messages meant for us
        if player.name == player_name && player.token == player_token
          player.receive_cards(cards: msg[:cards])
        end

        msg
      end
    end
  end
end

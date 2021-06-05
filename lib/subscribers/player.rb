module Subscribers
  # listens for player activity
  module Player
    module_function

    def register_listeners(player:)
      ActiveSupport::Notifications.subscribe("game.provides_game_tokens") do |_, msg|
        player_name = msg[:player_name]

        # only listen for messages meant for us
        if player.name == player_name
          player.receive_tokens(**msg.slice(:game_token, :player_token))

          {
            game_token: msg[:game_token], player_name: player_name
          }
        end
      end
    end
  end
end

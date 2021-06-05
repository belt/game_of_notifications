module Subscribers
  # listens for game activity
  module Game
    module_function

    def register_listeners(game:)
      ActiveSupport::Notifications.subscribe("player.enters_game") do |_, msg|
        player_name = msg[:player_name]
        player = ::Player.new(name: player_name, token: SecureRandom.uuid)
        game.players.add(player)
      end
    end
  end
end

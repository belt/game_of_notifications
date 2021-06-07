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

      ActiveSupport::Notifications.subscribe("player.requests_cards") do |_, msg|
        player_name = msg[:player_name]
        player = game.player_already_sitting?(player_name: player_name)

        # all players must requst cards
        cards = if game.game_token == msg_game_token(msg: msg) && player
          ack_msg = {
            player_name: player.name, game_token: game.game_token,
            player_token: player.token, cards: game.deal_cards(player_name: player_name)
          }

          if ack_msg[:cards]
            game.hands_dealt += 1
            ActiveSupport::Notifications.publish("player.receives_cards", ack_msg)
          end

          ack_msg[:cards]
        else
          Set.new
        end

        cards
      end

      ActiveSupport::Notifications.subscribe("player.receives_cards") do |_, msg|
        if game.game_token == msg_game_token(msg: msg)
          player = game.player_already_sitting?(player_name: player_name(msg: msg))

          # after all cards are dealt, the game completes i.e. score hands
          game.trigger(status: :completed) if player && game.started? && game.hands_dealt >= 6
        end

        msg
      end

      ActiveSupport::Notifications.subscribe("game.announce_winners") do |_, msg|
        # if this isn't the test environment, announce winners to STDOUT... pretty... easily
        if game.game_token == msg_game_token(msg: msg)
          qed_msg = { winners_for_game: msg.slice(:game_token, :winners) }
          Pry::ColorPrinter.pp(qed_msg) unless ENV["RUBY_ENV"] == "test"
          qed_msg
        end
      end

      ActiveSupport::Notifications.subscribe("player.requests_cards") do |_, msg|
        game.deal_cards(**msg.slice(:player_name))
      end
    end
  end
end

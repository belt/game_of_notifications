require "async"

# We got game
class Game
  attr_accessor :dealer, :hands_dealt
  attr_reader :players, :game_token, :hands, :winners

  def initialize
    @game_token = SecureRandom.uuid.freeze
    @players = Set.new
    @dealer = Dealer.new
    @dealer.token = SecureRandom.uuid

    open_table(player: @dealer)
    token_msg = {
      player_name: @dealer.name, game_token: @game_token, player_token: @dealer.token
    }
    ActiveSupport::Notifications.publish("game.provides_game_tokens", token_msg)

    @status = :not_started
    @hands_dealt = 0
    @hands = {}
    @winners = nil

    ::Subscribers::Game.register_listeners(game: self)
  end

  def acknowledge_player(player:)
    # NOTE: if table has space, provide game tokens
    return if open_table(player: player)

    player.token = SecureRandom.uuid
    players.add(player)

    token_msg = { player_name: player.name, game_token: game_token, player_token: player.token }
    ActiveSupport::Notifications.publish("game.provides_game_tokens", token_msg)
    token_msg
  end

  def open_table(player:)
    # NOTE: if table has space, don't queue
    return if table_has_space?

    token_msg = { player_name: player.name, game_token: game_token, player_token: player.token }
    ActiveSupport::Notifications.publish("game.player_in_queue", token_msg)
    token_msg
  end

  def table_has_space?
    players.count < 5
  end

  def player_already_sitting?(player_name:)
    return dealer if player_name == dealer.name

    # NOTE: being lazy and not going to write case-insensitive search specs (for now)
    players.detect do |player|
      player.name.casecmp(player_name).zero?
    end
  end

  STATUS_CALLBACKS = {
    started: lambda { |game|
      game.dealer.request_cards

      # Async do
        # round robin (SO much room for improvement e.g. fibers or concurrent-ruby or async)
        # either-way, we want to ensure all messages are processed before continuing
        game.players.map(&:request_cards)
      # end

      game
    },
    completed: lambda { |game|
      game.score_hands

      qed_msg = { game_token: game.game_token, winners: game.winners }
      ActiveSupport::Notifications.publish("game.announce_winners", qed_msg)

      # ensure both actions happen before continuing
      Async do
        game.dealer.open_new_pack
        game.players.map { |player| player.receive_cards(cards: Set.new) }
      end

      game
    }
  }.freeze

  def trigger(status:)
    return self if @status == status

    @status = status
    STATUS_CALLBACKS.fetch(status).call(self)
  end

  def started?
    @status == :started
  end

  def completed?
    @status == :completed
  end

  def deal_cards(player_name:)
    player = player_already_sitting?(player_name: player_name)
    return unless (started? && player) || player_name == dealer.name

    hand = Set.new([dealer.draw, dealer.draw])
    @hands[player_name] = hand

    hand
  end

  def scores
    hands.transform_values do |hand|
      { hand: hand, hand_total: sum_cards(cards: hand) }
    end
  end

  def score_hands
    best_score = highest_score

    @winners = scores.select { |_pn, hand| hand[:hand_total] == best_score }
  end

  def highest_score
    (_, winning_hand) = scores.max_by { |(_pn, hand)| hand[:hand_total] }
    winning_hand[:hand_total]
  end

  # NOTE: assumption aces = 14, jack = 11, queen = 12, king = 13
  def sum_cards(cards:)
    cards.sum { |card| ::CardTranslator.translate_card(card: card) }
  end
end

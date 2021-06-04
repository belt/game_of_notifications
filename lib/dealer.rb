require "active_support/configurable"

# a slight-of-hand specialist
class Dealer < Player
  include ActiveSupport::Configurable
  config_accessor :dealer_always_wins

  config.dealer_always_wins = false

  def initialize(**kwargs)
    @name = kwargs.fetch(:name, "I am root")
    @token = SecureRandom.uuid
    super name: @name
  end
end

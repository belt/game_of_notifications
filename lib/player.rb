require "active_support/core_ext/string"

# someone who takes risks
class Player
  attr_reader :name, :cards_in_hand

  def initialize(name:)
    @name = name
    raise ArgumentError, "invalid name" unless valid_name?
  end

  def valid_name?
    !name.strip.blank?
  end
end

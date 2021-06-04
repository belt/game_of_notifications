# a slight-of-hand specialist
class Dealer < Player
  def initialize(**kwargs)
    @name = kwargs.fetch(:name, "I am root")
    @token = SecureRandom.uuid
    super name: @name
  end
end

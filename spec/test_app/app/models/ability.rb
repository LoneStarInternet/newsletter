class Ability
  include CanCan::Ability

  def initialize(user)
    eval Newsletter.abilities
  end
end


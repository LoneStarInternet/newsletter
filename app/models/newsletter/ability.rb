if defined? CanCan::Ability
  module Newsletter::Ability
    include CanCan::Ability
  
    def initialize(user)
      can :read, :all
    end
  end
end


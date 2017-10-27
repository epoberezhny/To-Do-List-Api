class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, Project, user: user
  end
end

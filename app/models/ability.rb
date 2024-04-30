# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, Project, user_id: user.id
    can :manage, Task,    project: { user_id: user.id }
    can :manage, Comment, task:    { project: { user_id: user.id } }
  end
end

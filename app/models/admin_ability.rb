class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.is_admin?
      can :access, Role, is_common: false

      can :access, User

      can :activate, User do |user|
        !user.is_active?
      end

      can :deactivate, User do |user|
        user.is_active?
      end

      can :access, Action
    end
  end
end

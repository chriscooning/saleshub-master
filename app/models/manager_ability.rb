class ManagerAbility < Ability
  def initialize(user)
    user ||= User.new

    if user.is_manager?
      can :access, Action do |action|
        action_allowed?(user, permissions(user.access_table), action)
      end
    end
  end

  private

  def default_permissions
    {
      messages:  [:read],
      surveys:   [:read],
      news:      [:read],
      briefings: [:read, :create, :update, :delete, :edit],
      whats_ups: [:read, :create, :update, :delete, :edit]
    }
  end
end

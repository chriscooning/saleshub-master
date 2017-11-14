class Roles::BaseResource < Cyrax::Resource
  resource :role

  accessible_attributes :presentation, rule_ids: []

  def resource_attributes
    attributes = super
    attributes[:presentation].strip!
    attributes[:code] = attributes[:presentation].underscore.parameterize
    attributes
  end

  def authorize_resource!(action, resource)
    ability.authorize!(:access, resource)
  end

  def ability
    @_ability ||= if accessor.is_admin?
      AdminAbility.new(accessor)
    elsif accessor.is_manager?
      ManagerAbility.new(accessor)
    else
      Ability.new(accessor)
    end
  end
end

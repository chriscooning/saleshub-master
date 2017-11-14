class AccessTableTemplateDecorator < AppDecorator
  delegate_all

  def actions
    return [] if model.permissions.blank?
    @_actions ||= model.permissions.values.flatten.uniq
  end

  def action_names
    return [] if actions.blank?
    @_action_names ||= actions.map do |a|
      I18n.t("decorators.access_table_template.#{a}")
    end
  end

  def resources
    return [] if model.permissions.blank?
    return @_resources if @_resources.present?
    available_actions = actions
    entries = model.permissions.map do |resource_name, resource_actions|
      action_entries = available_actions.map do |available_action|
        [available_action, resource_actions.include?(available_action)]
      end
      [resource_name, Hash[action_entries]]
    end
    @_resources = Hash[entries]
  end
end
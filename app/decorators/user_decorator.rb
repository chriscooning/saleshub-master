class UserDecorator < AppDecorator
  delegate_all

  def name
    [model.first_name, model.last_name].join(' ')
  end

  def full_name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  def status_name
    is_active ? 'active' : 'inactive'
  end
end

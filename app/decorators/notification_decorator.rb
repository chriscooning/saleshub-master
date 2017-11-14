class NotificationDecorator < AppDecorator
  delegate_all

  def status
    model.is_active? ? 'Active' : 'Inactive'
  end
end

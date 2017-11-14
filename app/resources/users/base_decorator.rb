class Users::BaseDecorator < Cyrax::Decorator
  def name
    [first_name, last_name].join(' ')
  end

  def full_name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  def status_name
    is_active ? 'active' : 'inactive'
  end

  def self.decorate_collection(resource)
    CollectionDecorator.decorate(resource, decorator: self)
  end
end

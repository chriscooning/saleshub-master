class News::BaseDecorator < Cyrax::Decorator
  def published_at
    resource.pub_date || resource.created_at
  end
end
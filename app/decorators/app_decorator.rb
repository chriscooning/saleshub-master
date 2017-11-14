class AppDecorator < Draper::Decorator
  def self.collection_decorator_class
    PaginatingDecorator
  end
end
class MessagingController < ApplicationController
  private

  def paginate(scope)
    scope.paginate(pagination_scope)
  end

  def decorate(object)
    MessageDecorator.decorate(object)
  end

  def decorate_collection(collection)
    MessageDecorator.decorate_collection(collection)
  end

  def search_scope
    base_scope.search(params[:q])
  end

  def base_scope
    Message.where(message_type: message_type).published.by_position.accessible_by(current_user, :read)
  end
end

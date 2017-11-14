class NotificationsController < ApplicationController
  def close
    notification = find_notification
    session[:closed_notification_ids] ||= []
    session[:closed_notification_ids] << notification.id

    head :ok
  end

  private

  def find_notification
    Notification.find(params[:id])
  end
end

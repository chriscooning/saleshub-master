class Admin::NotificationsController < Admin::BaseController
  def new
    authorize!(:access, Action.new(:notifications, :create))

    @notification = Notification.new
  end

  def create
    authorize!(:access, Action.new(:notifications, :create))

    @notification = Notification.new(notification_params)

    if @notification.save
      flash[:notice] = 'Notification was successfully created'
      if @notification.is_active?
        broadcast "/channels/#{configatron.faye.channels.flashes}", { id: @notification.id,
                                      title: @notification.title,
                                      content: view_context.simple_format(@notification.body)
        }
      end
      redirect_to edit_admin_notification_path(@notification)
    else
      flash[:error] = 'Please check your input'
      render action: :new
    end
  end

  def index
    authorize!(:access, Action.new(:notifications, :read))

    @notifications = NotificationDecorator.decorate_collection(find_notifications)
  end

  def edit
    authorize!(:access, Action.new(:notifications, :edit))

    @notification = find_notification
  end

  def update
    authorize!(:access, Action.new(:notifications, :edit))

    @notification = find_notification
    @notification.assign_attributes(notification_params)

    if @notification.save
      flash[:notice] = 'Notification sucessfully updated'

      broadcast "/channels/#{configatron.faye.channels.flashes}", {
        id: @notification.id,
        is_active: @notification.is_active?,
        title: @notification.title,
        content: view_context.simple_format(@notification.body)
      }
      redirect_to edit_admin_notification_path(@notification)
    else
      flash[:notice] = 'Please check your input'
      render actoin: :edit
    end
  end

  def destroy
    authorize!(:access, Action.new(:notifications, :delete))

    @notification = find_notification

    if @notification.destroy
      flash[:notice] = 'Notification sucessfully deleted'

      broadcast "/channels/#{configatron.faye.channels.flashes}", {
        id: @notification.id,
        is_deleted: @notification.destroyed?
      }

      redirect_to admin_notifications_path
    else
      flash[:notice] = 'Notification can not be deleted'
      redirect_to admin_notifications_path
    end
  end

  private

  def find_notifications
    Notification.order('created_at DESC')
  end

  def find_notification
    Notification.find(params[:id])
  end

  def notification_params
    params.require(:notification).permit(:title, :body, :is_active)
  end
end

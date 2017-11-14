class ApplicationController < ActionController::Base
  DEFAULT_PER_PAGE = 10

  before_filter :authenticate_user!
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = 'Access denied'
    redirect_to root_path
  end

  rescue_from ::Errors::Dmc::NoConnection do |e|
    Rollbar.report_exception(e, rollbar_request_data, rollbar_person_data)
    render 'no_dmc_connection'
  end

  rescue_from ::Errors::Dmc::NotFound do |e|
    redirect_to '/404'
  end

  private

  def pagination_scope
    page = safe_integer(:page) || 1
    per_page = safe_integer(:per_page) || DEFAULT_PER_PAGE
    { page: page, per_page: per_page }
  end

  def safe_integer(name)
    param = params[name] && params[name].strip
    Integer(param) rescue nil
  end

  def current_ability
    if current_user && current_user.is_admin?
      AdminAbility.new(current_user)
    elsif current_user.is_manager?
      ManagerAbility.new(current_user)
    else
      Ability.new(current_user)
    end
  end

  def set_action(action)
    @action = action
  end

  def current_notifications
    return [] unless user_signed_in?
    return @current_notifications if @current_notifications
    closed_notification_ids = session[:closed_notification_ids] || []

    @current_notifications = Notification.where(is_active: true)
    if closed_notification_ids.present?
      @current_notifications = @current_notifications.where('id NOT IN (?)', closed_notification_ids)
    end

    @current_notifications
  end

  helper_method :current_notifications

  def broadcast(channel, data)
    message = { :channel => channel, :data => data, :authentication_token => configatron.faye.authentication_token }
    uri = URI.parse(configatron.faye.url)
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
end

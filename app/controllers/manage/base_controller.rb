module Manage
  class BaseController < ::ApplicationController
    include Cyrax::ControllerHelper
    respond_to :html

    private

    def current_ability
      @current_ability ||= if current_user.is_admin?
                             AdminAbility.new(current_user)
                           elsif current_user.is_manager?
                             ManagerAbility.new(current_user)
                           else
                             Ability.new(current_user)
                           end
    end
    helper_method :current_ability

    def authorize_by_type_and_action!(type, action)
      if type == Message::Types::BASIC
        authorize!(:access, Action.new(:messages, action))
      elsif type == Message::Types::BRIEFING
        authorize!(:access, Action.new(:briefings, action))
      elsif type == Message::Types::WHATS_UP
        authorize!(:access, Action.new(:whats_ups, action))
      else
        raise CanCan::AccessDenied
      end
    end
  end
end

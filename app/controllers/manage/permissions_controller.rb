module Manage
  class PermissionsController < BaseController
    def edit
      user = User.without_admins.find(params[:user_id])
      authorize!(:access, user)
      @user = UserDecorator.decorate(user)
    end

    def update
      user = User.without_admins.find(params[:user_id])
      authorize!(:access, user)

      user.rules.clear

      params[:user][:rules].each do |scope, rules_by_operand|
        rules_by_operand.each do |operand, rules_by_operation|
          rules_by_operation.each do |operation, should_be_allowed|
            rules = Rule.by_scope(scope).by_operand(operand).by_operation(operation)
            allow_rule = rules.allow.first
            deny_rule = rules.deny.first

            if should_be_allowed.eql?('1')
              unless user.role.rules.include?(allow_rule)
                user.rules << allow_rule
              end
            else
              if user.role.rules.include?(allow_rule)
                user.rules << deny_rule
              end
            end
          end
        end
      end

      flash[:notice] = 'Permissions sucessfully updated'

      redirect_to action: :edit
    end

    private

    def resource
      @_resource ||= Users::RulesResource.new(as: current_user, params: params)
    end
  end
end


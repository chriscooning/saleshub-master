class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :access, Action do |action|
      action_allowed?(user, action)
    end
  end

  private

  def action_allowed?(user, action)
    allow_rules = allow_rules_for(user)

    operand = action.resource_name.to_s.singularize
    operations = action.names.map(&:to_s)

    rules = allow_rules.select{ |rule| rule.operand.code.eql?(operand) }
    operation_codes = rules.map(&:operation).map(&:code)

    if action.or?
      operations.any?{ |operation| operation_codes.include?(operation) }
    elsif action.and?
      operations.all?{ |operation| operation_codes.include?(operation) }
    else
      raise "Invalid action: #{action.inspect}"
    end
  end

  def allow_rules_for(user)
    role_allow_rules = user.role.rules.allow.includes(:operation, :operand)
    user_allow_rules = user.rules.allow.includes(:operation, :operand)
    user_deny_rules  = user.rules.deny.includes(:operation, :operand)

    allow_rules = []
    allow_rules << user_allow_rules

    role_allow_rules.each do |role_allow_rule|
      unless user_deny_rules.any?{ |rule| rule.opposite?(role_allow_rule) }
        allow_rules << role_allow_rule
      end
    end

    allow_rules.flatten.uniq
  end
end

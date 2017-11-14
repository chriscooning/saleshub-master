# == Schema Information
#
# Table name: rules
#
#  id           :integer          not null, primary key
#  is_allow     :boolean
#  is_global    :boolean
#  operand_id   :integer
#  operation_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Rule < ActiveRecord::Base
  belongs_to :operand
  belongs_to :operation

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :users

  class << self
    def global
      where(is_global: true)
    end

    def local
      where(is_global: false)
    end

    def allow
      where(is_allow: true)
    end

    def deny
      where(is_allow: false)
    end

    def by_operand(code)
      joins(:operand).where(operands: { code: code })
    end

    def by_operation(code)
      joins(:operation).where(operations: { code: code })
    end

    def by_scope(scope)
      case scope.to_sym
        when :global then global
        when :local then local
        else raise 'Undefined scope'
      end
    end
  end

  def opposite
    Rule.
      where(is_global: is_global).
      where(operand_id: operand_id).
      where(operation_id: operation_id).
      where(is_allow: !is_allow).first
  end

  def opposite?(rule)
    is_global.eql?(rule.is_global) &&
      operand_id.eql?(rule.operand_id) &&
      operation_id.eql?(rule.operation_id) &&
      is_allow.eql?(!rule.is_allow)
  end
end

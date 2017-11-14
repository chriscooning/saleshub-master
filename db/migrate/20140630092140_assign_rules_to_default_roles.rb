class AssignRulesToDefaultRoles < ActiveRecord::Migration
  def self.up
    user_role = Role.find_by_code('user')
    rules = []
    rules << Rule.global.allow.joins(:operation).where(operations: { code: 'read' })
    rules << Rule.local.allow.joins(:operand).where(operands: { code: 'whats_up' })
    user_role.rules = rules.flatten
    user_role.save

    manager_role = Role.find_by_code('manager')
    rules = []
    rules << Rule.global.allow.joins(:operation).where(operations: { code: 'read' })
    rules << Rule.global.allow.joins(:operand).where(operands: { code: ['briefing', 'whats_up'] })
    manager_role.rules = rules.flatten
    manager_role.save
  end

  def self.down
    raise IrreversibleMigration
  end
end

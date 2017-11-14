class SetRoleIdForUsers < ActiveRecord::Migration
  def self.up
    user_role = Role.find_by_code('user')
    manager_role = Role.find_by_code('manager')
    admin_role = Role.find_by_code('admin')

    User.where(role: 0).update_all(role_id: admin_role.id)
    User.where(role: 1).update_all(role_id: user_role.id)
    User.where(role: 2).update_all(role_id: manager_role.id)
  end

  def self.down
    raise IrreversibleMigration
  end
end

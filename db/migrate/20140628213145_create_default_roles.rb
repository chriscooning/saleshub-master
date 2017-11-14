class CreateDefaultRoles < ActiveRecord::Migration
  def self.up
    Role.create(
      [
        {presentation: 'User', code: 'user', is_default: true},
        {presentation: 'Manager', code: 'manager'},
        {presentation: 'Admin', code: 'admin', is_common: true}
      ]
    )
  end

  def self.down
    raise IrreversibleMigration
  end
end

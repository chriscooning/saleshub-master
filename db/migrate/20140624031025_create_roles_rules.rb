class CreateRolesRules < ActiveRecord::Migration
  def change
    create_table :roles_rules do |t|
      t.integer :role_id
      t.integer :rule_id
    end
  end
end

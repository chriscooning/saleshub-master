class CreateRulesUsers < ActiveRecord::Migration
  def change
    create_table :rules_users do |t|
      t.integer :user_id
      t.integer :rule_id
    end
  end
end

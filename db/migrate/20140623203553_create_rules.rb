class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.boolean :is_allow
      t.boolean :is_global
      t.integer :operand_id
      t.integer :operation_id

      t.timestamps
    end
  end
end

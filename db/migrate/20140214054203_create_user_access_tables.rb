class CreateUserAccessTables < ActiveRecord::Migration
  def change
    create_table :user_access_tables do |t|
      t.integer :user_id, null: false
      t.text :permissions, null: false
      t.timestamps
    end
    add_index :user_access_tables, :user_id
  end
end
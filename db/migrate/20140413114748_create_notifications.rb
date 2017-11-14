class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :body
      t.boolean :is_active

      t.timestamps
    end
  end
end

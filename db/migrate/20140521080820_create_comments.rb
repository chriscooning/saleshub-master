class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :message_id
      t.integer :parent_id
      t.integer :created_by_id
      t.text :content

      t.timestamps
    end
  end
end

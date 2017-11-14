class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :author_name
      t.text :body, null: false
      t.integer :message_type, null: false

      t.timestamps
    end
  end
end

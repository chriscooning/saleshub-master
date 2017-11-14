class CreateMessageGalleries < ActiveRecord::Migration
  def change
    create_table :message_galleries do |t|
      t.integer :message_id
      t.integer :created_by_id

      t.timestamps
    end
  end
end

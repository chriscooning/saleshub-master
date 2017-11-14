class CreateMessageGalleryImages < ActiveRecord::Migration
  def change
    create_table :message_gallery_images do |t|
      t.integer :message_gallery_id
      t.string :file

      t.timestamps
    end
  end
end

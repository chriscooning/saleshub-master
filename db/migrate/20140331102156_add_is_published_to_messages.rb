class AddIsPublishedToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :is_published, :boolean, default: true
  end
end

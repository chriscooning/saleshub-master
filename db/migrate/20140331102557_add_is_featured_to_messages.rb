class AddIsFeaturedToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :is_featured, :boolean, default: false
  end
end

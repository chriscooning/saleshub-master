class AddImageToNewsEntries < ActiveRecord::Migration
  def change
    add_column :news_entries, :image, :string
  end
end

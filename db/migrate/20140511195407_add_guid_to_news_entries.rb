class AddGuidToNewsEntries < ActiveRecord::Migration
  def change
    add_column :news_entries, :guid, :string
  end
end

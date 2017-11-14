class AddCreatedByIdToNewsEntries < ActiveRecord::Migration
  def change
    add_column :news_entries, :created_by_id, :integer
  end
end

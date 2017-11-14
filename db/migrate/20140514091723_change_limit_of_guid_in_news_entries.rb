class ChangeLimitOfGuidInNewsEntries < ActiveRecord::Migration
  def up
    change_column :news_entries, :guid, :string, limit: 1024
  end

  def down
    change_column :news_entries, :guid, :string, limit: nil
  end
end

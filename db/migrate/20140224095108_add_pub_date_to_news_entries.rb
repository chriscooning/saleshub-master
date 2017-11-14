class AddPubDateToNewsEntries < ActiveRecord::Migration
  def change
    add_column :news_entries, :pub_date, :datetime
    add_index :news_entries, :pub_date
  end
end

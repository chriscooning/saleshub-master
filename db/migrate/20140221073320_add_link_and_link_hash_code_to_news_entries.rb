class AddLinkAndLinkHashCodeToNewsEntries < ActiveRecord::Migration
  def change
    add_column :news_entries, :link, :string, limit: 2048
    add_column :news_entries, :link_hashcode, :bigint

    add_index  :news_entries, :link_hashcode
  end
end

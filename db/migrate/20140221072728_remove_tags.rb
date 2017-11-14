class RemoveTags < ActiveRecord::Migration
  def change
    remove_index :tags, :name
    remove_index :taggings, name: 'taggings_idx'
    drop_table :taggings
    drop_table :tags
  end
end

class CreateNewsEntries < ActiveRecord::Migration
  def change
    create_table :news_entries do |t|
      t.integer :news_type
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end

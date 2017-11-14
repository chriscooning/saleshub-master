class ChangeMessagesAndNewsEntriesTextFieldLimits < ActiveRecord::Migration
  def change
    change_column :messages, :title, :string, limit: 120
    change_column :messages, :body, :text, limit: 300

    change_column :news_entries, :title, :string, limit: 120
    change_column :news_entries, :title, :string, limit: 800
  end
end

class AddTitleToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :title, :string, null: false
  end
end

class AddIsAnonymousToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :is_anonymous, :boolean, default: true
  end
end

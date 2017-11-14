class AddCreatedByIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :created_by_id, :integer
  end
end

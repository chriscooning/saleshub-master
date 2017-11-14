class RenamePriorityToPositionInMessages < ActiveRecord::Migration
  def change
    rename_column :messages, :priority, :position
  end
end

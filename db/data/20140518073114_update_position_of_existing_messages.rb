class UpdatePositionOfExistingMessages < ActiveRecord::Migration
  def self.up
    messages = Message.order('position DESC, created_at DESC').reverse
    messages.each_with_index do |message, index|
      message.update_column(:position, index + 1)
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end

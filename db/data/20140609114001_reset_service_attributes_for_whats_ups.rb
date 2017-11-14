class ResetServiceAttributesForWhatsUps < ActiveRecord::Migration
  def self.up
    Message.where(message_type: Message::Types::WHATS_UP).update_all(is_anonymous: false, is_published: true, is_featured: false)
  end

  def self.down
    raise IrreversibleMigration
  end
end

class AddWhatsUpsToUserAccessTables < ActiveRecord::Migration
  def self.up
    User.where(role: User::Roles::USER).each do |user|
      access_table = user.access_table
      if access_table.present?
        access_table.permissions[:whats_ups] = [:read]
        access_table.save
      end
    end
end

  def self.down
    raise IrreversibleMigration
  end
end

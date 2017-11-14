class CreateDefaultConfiguration < ActiveRecord::Migration
  def self.up
    Configuration.create(name: 'Default', code: 'default')
  end

  def self.down
    raise IrreversibleMigration
  end
end

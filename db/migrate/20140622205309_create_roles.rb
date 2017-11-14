class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :code
      t.string :presentation
      t.boolean :is_common, default: false
      t.boolean :is_default, default: false

      t.timestamps
    end
  end
end

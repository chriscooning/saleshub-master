class CreateAccessTableTemplates < ActiveRecord::Migration
  def change
    create_table :access_table_templates do |t|
      t.text :permissions, null: false

      t.timestamps
    end
  end
end

class CreateConfigurationOptions < ActiveRecord::Migration
  def change
    create_table :configuration_options do |t|
      t.integer :configuration_id
      t.string :code
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end

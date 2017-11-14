class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.string :code
      t.string :presentation

      t.timestamps
    end
  end
end

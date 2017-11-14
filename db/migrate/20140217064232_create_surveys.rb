class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.integer :author_id, null: false
      t.text :customer_name, null: false
      t.string :phone, null: false
      t.text :address, null: false
      t.string :zipcode, null: false
      t.string :city, null: false
      t.string :state, null: false, limit: 2
      t.text :summary, null: false
      t.integer :last_interaction_rating, null: false

      t.timestamps
    end
    add_index :surveys, :author_id
    add_index :surveys, :zipcode
    add_index :surveys, :state
  end
end

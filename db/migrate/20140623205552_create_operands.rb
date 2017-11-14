class CreateOperands < ActiveRecord::Migration
  def change
    create_table :operands do |t|
      t.string :code
      t.string :presentation
      t.timestamps
    end
  end
end

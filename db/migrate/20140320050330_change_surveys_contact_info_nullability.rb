class ChangeSurveysContactInfoNullability < ActiveRecord::Migration
  def change
    change_column :surveys, :phone,   :string, null: true
    change_column :surveys, :address, :text,   null: true
    change_column :surveys, :zipcode, :string, null: true
    change_column :surveys, :city,    :string, null: true
    change_column :surveys, :state,   :string, null: true
  end
end

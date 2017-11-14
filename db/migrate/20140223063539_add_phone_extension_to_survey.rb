class AddPhoneExtensionToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :phone_extension, :string
  end
end

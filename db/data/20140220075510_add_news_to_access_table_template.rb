class AddNewsToAccessTableTemplate < ActiveRecord::Migration
  def self.up
    AccessTableTemplate.destroy_all
    AccessTableTemplate.create!(
      permissions: {
        messages: [:read, :create, :edit, :delete],
        surveys:  [:read, :create, :edit, :delete],
        news:     [:read, :create, :edit, :delete]
      }
    )
  end
end

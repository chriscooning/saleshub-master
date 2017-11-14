class CreateAccessTableTemplateInstance < ActiveRecord::Migration
  def self.up
    AccessTableTemplate.create!(
      permissions: {
        messages: [:read, :create, :edit, :delete],
        surveys:  [:read, :create, :edit, :delete]
      }
    )
  end

  def self.down
    AccessTableTemplate.destroy_all
  end
end

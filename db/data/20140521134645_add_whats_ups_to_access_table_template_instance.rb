class AddWhatsUpsToAccessTableTemplateInstance < ActiveRecord::Migration
  def self.up
    template = AccessTableTemplate.last
    template.permissions[:whats_ups] = [:read, :create, :edit, :delete]
    template.save
  end

  def self.down
    template = AccessTableTemplate.last
    template.permissions.delete(:whats_ups)
    template.save
  end
end

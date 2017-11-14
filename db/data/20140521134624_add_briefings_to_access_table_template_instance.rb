class AddBriefingsToAccessTableTemplateInstance < ActiveRecord::Migration
  def self.up
    template = AccessTableTemplate.last
    template.permissions[:briefings] = [:read, :create, :edit, :delete]
    template.save
  end

  def self.down
    template = AccessTableTemplate.last
    template.permissions.delete(:briefings)
    template.save
  end
end
